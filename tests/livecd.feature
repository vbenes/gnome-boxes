Feature: LiveCD

  Background:
    * Make sure that gnome-boxes is running
    * Wait until overview is loaded

  @new_local_livecd_box_via_file
  Scenario: New local liveCD box via file
    * Create new box from file "Downloads/Core-current.iso"
    * Press "Create"
    * Wait for "sleep 3" end
    * Hit "Enter"
    * Wait for "sleep 5" end
    * Save IP for machine "Core-current"
    * Press "back" in "Core-current" vm
    Then Box "Core-current" "does" exist
    Then Ping "Core-current"

  @new_local_livecd_box_via_iso
  Scenario: New local liveCD box
    * Create new box from menu "Core-current"
    * Press "Create"
    * Wait for "sleep 3" end
    * Hit "Enter"
    * Wait for "sleep 5" end
    * Save IP for machine "Core-current"
    * Press "back" in "Core-current" vm
    Then Box "Core-current" "does" exist
    Then Ping "Core-current"

  @create_five_local_liveCD_boxes
  Scenario: Create five liveCD boxes
    * Create new box "Core-current"
    Then Ping "Core-current"
    * Create new box "Core-current 2" from "Core-current" menuitem
    Then Ping "Core-current 2"
    * Create new box "Core-current 3" from "Core-current" menuitem
    Then Ping "Core-current 3"
    * Create new box "Core-current 4" from "Core-current" menuitem
    Then Ping "Core-current 4"
    * Create new box "Core-current 5" from "Core-current" menuitem
    Then Ping "Core-current 5"

  @go_into_local_livecd_box
  Scenario: Go into local liveCD box
    * Create new box "Core-current"
    * Box "Core-current" "does" exist
    * Ping "Core-current"
    * Go into "Core-current" box
    * Wait for "sleep 2" end
    * Type text "sudo ifconfig eth0 down" and return
    * Wait for "sleep 5" end
    Then Cannot ping "Core-current"

  @delete_local_livecd_box
  Scenario: Delete local liveCD box
    * Create new box "Core-current"
    * Select "Core-current" box
    * Press "Delete"
    * Close warning
    * Wait for "sleep 2" end
    Then Box "Core-current" "does not" exist
    Then Cannot ping "Core-current"

  @delete_local_livecd_box_via_context_menu
  Scenario: Delete local liveCD box via context menu
    * Create new box "Core-current"
    * Launch "Delete" for "Core-current" box
    * Close warning
    * Wait for "sleep 2" end
    Then Box "Core-current" "does not" exist
    Then Cannot ping "Core-current"

  @undo_delete_local_livecd_box
  Scenario: Undo Delete of local liveCD box
    * Create new box "Core-current"
    When Box "Core-current" "does" exist
    When Ping "Core-current"
    * Select "Core-current" box
    * Press "Delete"
    * Press "Undo"
    Then Box "Core-current" "does" exist
    Then Ping "Core-current"

  @delete_five_local_livecd_boxes
  Scenario: Delete five local liveCD boxes
    * Create new box "Core-current"
    * Create new box "Core-current 2" from "Core-current" menuitem
    * Create new box "Core-current 3" from "Core-current" menuitem
    * Create new box "Core-current 4" from "Core-current" menuitem
    * Create new box "Core-current 5" from "Core-current" menuitem
    * Select "Core-current" box
    * Select "Core-current 2" box
    * Select "Core-current 3" box
    * Select "Core-current 4" box
    * Select "Core-current 5" box
    * Press "Delete"
    * Close warning
    * Wait for "sleep 2" end
    Then Box "Core-current" "does not" exist
    Then Cannot ping "Core-current"
    Then Box "Core-current 2" "does not" exist
    Then Cannot ping "Core-current 2"
    Then Box "Core-current 3" "does not" exist
    Then Cannot ping "Core-current 3"
    Then Box "Core-current 4" "does not" exist
    Then Cannot ping "Core-current 4"
    Then Box "Core-current 5" "does not" exist
    Then Cannot ping "Core-current 5"

  # https://bugzilla.gnome.org/show_bug.cgi?id=742392
  @poweroff_local_livecd_box
  Scenario: Power off local liveCD box
    * Create new box "Core-current"
    * Box "Core-current" "does" exist
    * Ping "Core-current"
    * Go into "Core-current" box
    * Wait for "sleep 1" end
    * Type text "sudo poweroff" and return
    * Wait for "sleep 20" end
    Then Box "Core-current" "does not" exist
    Then Cannot ping "Core-current"

  @pause_livecd_box
  Scenario: Pause liveCD box
    * Create new box "Core-current"
    When Ping "Core-current"
    * Select "Core-current" box
    * Press "Pause"
    * Wait for "sleep 8" end
    Then Cannot ping "Core-current"

  @resume_livecd_box
  Scenario: Resume liveCD box
    * Create new box "Core-current"
    * Select "Core-current" box
    * Press "Pause"
    * Wait for "sleep 10" end
    * Go into "Core-current" box
    * Wait for "sleep 10" end
    Then Ping "Core-current"

  @force_shutdown_local_machine
  Scenario: Force off local liveCD box
    * Create new box "Core-current"
    * Launch "Properties" for "Core-current" box
    * Press "System"
    * Press "Force Shutdown"
    Then Box "Core-current" "does" exist
    Then Cannot ping "Core-current"

  @livecd_restart_persistence
  Scenario: LiveCD restart persistence
    * Initiate new box "Core-current" installation
    * Initiate new box "Core-current 2" installation from "Core-current" menuitem
    * Import machine "Core-5 3" from image "Downloads/Core-5.3.qcow2"
    * Import machine "Core-5 4" from image "Downloads/Core-5.3.vmdk"
    * Quit Boxes
    * Start Boxes
    Then Box "Core-current" "does" exist
    Then Box "Core-current 2" "does" exist
    Then Box "Core-5 3" "does" exist
    Then Box "Core-5 4" "does" exist
