// This file is part of GNOME Boxes. License: LGPLv2+
using GVir;
using Gtk;

private class Boxes.LibvirtBroker : Boxes.Broker {
    private static LibvirtBroker broker;
    private HashTable<string,GVir.Connection> connections;
    private GLib.List<GVir.Domain> pending_domains;

    public static LibvirtBroker get_default () {
        if (broker == null)
            broker = new LibvirtBroker ();

        return broker;
    }

    private LibvirtBroker () {
        connections = new HashTable<string, GVir.Connection> (str_hash, str_equal);
        pending_domains = new GLib.List<GVir.Domain> ();
    }

    public GVir.Connection get_connection (string name) {
        return_if_fail (broker != null);
        return broker.connections.get (name);
    }

    public async LibvirtMachine add_domain (CollectionSource source, GVir.Connection connection, GVir.Domain domain)
                                            throws GLib.Error {
        return_if_fail (broker != null);

        if (pending_domains.find (domain) != null) {
            // Already being added asychronously
            SourceFunc callback = add_domain.callback;
            ulong id = 0;
            id = App.app.collection.item_added.connect ((item) => {
                if (!(item is LibvirtMachine) || (item as LibvirtMachine).domain != domain)
                    return;

                App.app.collection.disconnect (id);
                callback ();
            });

            yield;
        }

        var machine = domain.get_data<LibvirtMachine> ("machine");
        if (machine != null)
            return machine; // Already added

        pending_domains.append (domain);
        machine = yield new LibvirtMachine (source, connection, domain);
        pending_domains.remove (domain);

        domain.set_data<LibvirtMachine> ("machine", machine);
        App.app.collection.add_item (machine);

        if (source.name != App.DEFAULT_SOURCE_NAME)
            return machine;


        try {
            var config = machine.domain.get_config (0);
            yield VMConfigurator.update_existing_domain (config, connection);
            machine.domain.set_config (config);
        } catch (GLib.Error e) {
            warning ("Failed to update domain '%s': %s", domain.get_name (), e.message);
        }

        return machine;
    }

    // New == Added after Boxes launch
    private async void try_add_new_domain (CollectionSource source, GVir.Connection connection, GVir.Domain domain) {
        try {
            yield add_domain (source, connection, domain);
        } catch (GLib.Error error) {
            warning ("Failed to create source '%s': %s", source.name, error.message);
        }
    }

    // Existing == Existed before Boxes was launched
    private async void try_add_existing_domain (CollectionSource source,
                                                GVir.Connection  connection,
                                                GVir.Domain      domain) {
        try {
            var machine = yield add_domain (source, connection, domain);
            var config = machine.domain_config;

            // These instance will take care of their own lifecycles
            if (VMConfigurator.is_install_config (config) || VMConfigurator.is_live_config (config)) {
                debug ("Continuing installation/live session for '%s', ..", machine.name);
                new VMCreator.for_install_completion (machine);
            } else if (VMConfigurator.is_import_config (config)) {
                debug ("Continuing import of '%s', ..", machine.name);
                new VMImporter.for_import_completion (machine);
            } else if (VMConfigurator.is_libvirt_system_import_config (config)) {
                debug ("Continuing import of '%s', ..", machine.name);
                new LibvirtSystemVMImporter.for_import_completion (machine);
            }
        } catch (GLib.Error error) {
            warning ("Failed to create source '%s': %s", source.name, error.message);
        }
    }

    public override async void add_source (CollectionSource source) {
        if (connections.lookup (source.name) != null)
            return;

        var connection = new GVir.Connection (source.uri);

        try {
            yield connection.open_async (null);
            yield connection.fetch_domains_async (null);
            yield connection.fetch_storage_pools_async (null);
            yield Boxes.ensure_storage_pool (connection);
        } catch (GLib.Error error) {
            warning (error.message);
        }

        connections.insert (source.name, connection);

        foreach (var domain in connection.get_domains ())
            yield try_add_existing_domain (source, connection, domain);

        connection.domain_removed.connect ((connection, domain) => {
            var machine = domain.get_data<LibvirtMachine> ("machine");
            if (machine == null)
                return; // Looks like we removed the domain ourselves. Nothing to do then..

            App.app.delete_machine (machine, false);
        });

        connection.domain_added.connect ((connection, domain) => {
            debug ("New domain '%s'", domain.get_name ());
            try_add_new_domain.begin (source, connection, domain);
        });

        yield base.add_source (source);
    }
}

