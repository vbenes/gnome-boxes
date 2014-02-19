// This file is part of GNOME Boxes. License: LGPLv2+

[GtkTemplate (ui = "/org/gnome/Boxes/ui/empty-boxes.ui")]
private class Boxes.EmptyBoxes : Gtk.Stack, Boxes.UI {
    // See FIXME on Topbar class
    public Clutter.Actor actor {
        get {
            if (gtk_actor == null)
                gtk_actor = new Clutter.Actor ();
            return gtk_actor;
        }
    }
    public UIState previous_ui_state { get; protected set; }
    public UIState ui_state { get; protected set; }

    private Clutter.Actor gtk_actor;

    [GtkChild]
    private Gtk.Box grid_box;

    public EmptyBoxes () {
        App.app.call_when_ready (on_app_ready);
    }

    private void on_app_ready () {
        update_visibility ();

        App.app.collection.item_added.connect (update_visibility);
        App.app.collection.item_removed.connect (update_visibility);
    }

    private void update_visibility () {
        var visible = App.app.collection.items.length == 0;
        if (visible && visible_child != grid_box)
            visible_child = grid_box;

        if (ui_state != UIState.COLLECTION)
            return;

        if (visible)
            App.app.below_bin.set_visible_child_name ("empty-boxes");
        else
            App.app.below_bin.set_visible_child_name ("collection-view");
    }
}
