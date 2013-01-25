/* govirt.vapi generated by lt-vapigen, do not modify. */

[CCode (cprefix = "Ovirt", gir_namespace = "GoVirt", gir_version = "1.0", lower_case_cprefix = "ovirt_")]
namespace Ovirt {
	[CCode (cheader_filename = "govirt/govirt.h", type_id = "ovirt_proxy_get_type ()")]
	public class Proxy : Rest.Proxy {
		[CCode (has_construct_function = false)]
		public Proxy (string uri);
		public bool fetch_ca_certificate () throws GLib.Error;
		public async GLib.ByteArray fetch_ca_certificate_async (GLib.Cancellable? cancellable) throws GLib.Error;
		public bool fetch_vms () throws GLib.Error;
		public async unowned GLib.List<Ovirt.Vm> fetch_vms_async (GLib.Cancellable? cancellable) throws GLib.Error;
		public unowned GLib.List<Ovirt.Vm> get_vms ();
		public Ovirt.Vm lookup_vm (string vm_name);
		[NoAccessorMethod]
		public bool admin { get; set; }
		[NoAccessorMethod]
		public GLib.ByteArray ca_cert { owned get; set; }
	}
	[CCode (cheader_filename = "govirt/govirt.h", type_id = "ovirt_vm_get_type ()")]
	public class Vm : GLib.Object {
		[CCode (has_construct_function = false)]
		public Vm ();
		public bool get_ticket (Ovirt.Proxy proxy) throws GLib.Error;
		public async bool get_ticket_async (Ovirt.Proxy proxy, GLib.Cancellable? cancellable) throws GLib.Error;
		public bool start (Ovirt.Proxy proxy) throws GLib.Error;
		public async bool start_async (Ovirt.Proxy proxy, GLib.Cancellable? cancellable) throws GLib.Error;
		public bool stop (Ovirt.Proxy proxy) throws GLib.Error;
		public async bool stop_async (Ovirt.Proxy proxy, GLib.Cancellable? cancellable) throws GLib.Error;
		[NoAccessorMethod]
		public Ovirt.VmDisplay display { owned get; set; }
		[NoAccessorMethod]
		public string href { owned get; set; }
		[NoAccessorMethod]
		public string name { owned get; set; }
		[NoAccessorMethod]
		public Ovirt.VmState state { get; set; }
		[NoAccessorMethod]
		public string uuid { owned get; set; }
	}
	[CCode (cheader_filename = "govirt/govirt.h", type_id = "ovirt_vm_display_get_type ()")]
	public class VmDisplay : GLib.Object {
		[CCode (has_construct_function = false)]
		public VmDisplay ();
		[NoAccessorMethod]
		public string address { owned get; set; }
		[NoAccessorMethod]
		public uint expiry { get; set; }
		[NoAccessorMethod]
		public uint monitor_count { get; set; }
		[NoAccessorMethod]
		public uint port { get; set; }
		[NoAccessorMethod]
		public uint secure_port { get; set; }
		[NoAccessorMethod]
		public string ticket { owned get; set; }
		[NoAccessorMethod]
		public Ovirt.VmDisplayType type { get; set; }
	}
	[CCode (cheader_filename = "govirt/govirt.h", cprefix = "OVIRT_VM_DISPLAY_", type_id = "ovirt_vm_display_type_get_type ()")]
	public enum VmDisplayType {
		SPICE,
		VNC
	}
	[CCode (cheader_filename = "govirt/govirt.h", cprefix = "OVIRT_VM_STATE_", type_id = "ovirt_vm_state_get_type ()")]
	public enum VmState {
		DOWN,
		UP,
		REBOOTING
	}
	[CCode (cheader_filename = "govirt/govirt.h", cprefix = "OVIRT_PROXY_")]
	public errordomain ProxyError {
		PARSING_FAILED,
		ACTION_FAILED,
		FAULT;
		public static GLib.Quark quark ();
	}
	[CCode (cheader_filename = "govirt/govirt.h", cprefix = "OVIRT_REST_CALL_ERROR_")]
	public errordomain RestCallError {
		XML;
		public static GLib.Quark quark ();
	}
}