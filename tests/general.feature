Feature: General

  Background:
    * Make sure that gnome-boxes is running
    * Wait until overview is loaded

  @open_help_via_shortcut
  Scenario: Open help via shortcut
    * Hit "<F1>"
    Then Help is shown

  @open_help_via_menu
  Scenario: Open help from menu
    * Select "Help" from supermenu
    Then Help is shown

  @open_about_via_menu
  Scenario: Open about from menu
    * Select "About" from supermenu
    * Press "Credits"
    * Press "About"
    Then About is shown

  @quit_via_panel
  Scenario: Quit Boxes via super menu
    * Select "Quit" from supermenu
    Then Boxes are not running

  @quit_via_shortcut
  Scenario: Quit Boxes via shortcut
    * Quit Boxes
    Then Boxes are not running

  @no_boxes
  Scenario: No boxes installed
    Then No box is visible

  @download_iso_http
  Scenario: Download iso http
    * Create new box from url "http://ftp.vim.org/os/Linux/distr/tinycorelinux/6.x/x86_64/archive/6.3/CorePure64-6.3.iso"
    * Wait for "sleep 2" end
    * Hit "Enter"
    * Save IP for machine "Core-6"
    * Press "back" in "Core-6" vm
    Then Box "Core-6" "does" exist
    Then Ping "Core-6"

  @customize_machine_before_installation
  Scenario: Customize machine before installation
    * Create new box from menu "Core-current"
    * Customize mem to "64.0" MB
    * Press "Create"
    * Wait for "sleep 10" end
    Then "65536 KiB" is visible with command "DOM=$(virsh list |grep boxes |awk {'print $1'}); virsh dominfo $DOM"

  @rename_via_button
  Scenario: Rename via button
    * Initiate new box "Core-current" installation
    * Launch "Properties" for "Core-current" box
    * Rename "Core-current" to "Kernel-6" via "button"
    * Hit "Esc"
    * Quit Boxes
    * Start Boxes
    Then Box "Kernel-6" "does" exist

  @rename_via_label
  Scenario: Rename via label
    * Initiate new box "Core-current" installation
    * Launch "Properties" for "Core-current" box
    * Rename "Core-current" to "Kernel-6" via "label"
    * Hit "Esc"
    * Quit Boxes
    * Start Boxes
    Then Box "Kernel-6" "does" exist

  @start_box_from_console
  Scenario: Start box directly from console
    * Create new box "Core-current"
    Then Ping "Core-current"
    * Quit Boxes
    * Start box name "Core-current"
    * Type text "sudo ifconfig eth0 down" and return
    * Wait for "sleep 2" end
    Then Cannot ping "Core-current"

  @search_via_shortcut
  Scenario: Search via shotcut
    * Initiate new box "Core-current" installation
    * Initiate new box "Core-current 2" installation from "Core-current" menuitem
    * Hit "<Ctrl><f>"
    * Type text "Core-current 2" and return
    Then Box "Core-current 2" "does" exist
    Then Box "Core-current" "does not" exist
    * Hit "<Ctrl><a>"
    * Type text "Core" and return
    Then Box "Core-current 2" "does" exist
    Then Box "Core-current" "does" exist

  @search_via_button
  Scenario: Search via button
    * Initiate new box "Core-current" installation
    * Initiate new box "Core-current 2" installation from "Core-current" menuitem
    * Press "Search"
    * Type text "Core-current 2" and return
    Then Box "Core-current 2" "does" exist
    Then Box "Core-current" "does not" exist
    * Hit "<Ctrl><a>"
    * Type text "Core" and return
    Then Box "Core-current 2" "does" exist
    Then Box "Core-current" "does" exist

  @search_escape
  Scenario: Return from search via Esc
    * Initiate new box "Core-current" installation
    * Initiate new box "Core-current 2" installation from "Core-current" menuitem
    * Hit "<Ctrl><f>"
    * Type text "Core-current 2" and return
    Then Box "Core-current 2" "does" exist
    Then Box "Core-current" "does not" exist
    * Hit "Esc"
    Then Box "Core-current 2" "does" exist
    Then Box "Core-current" "does" exist

  @selections
  Scenario: Selection menu
    * Initiate new box "Core-current" installation
    * Initiate new box "Core-current 2" installation from "Core-current" menuitem
    * Initiate new box "Core-current 3" installation from "Core-current" menuitem
    * Select "Core-current 2" box
    * Select "Core-current 3" box
    * Press "Pause"
    * Wait for "sleep 2" end
    * Press "Select Items"
    * Press "(Click on items to select them)"
    * Press "Select All"
    * Press "3 selected"
    * Press "Select None"
    * Press "(Click on items to select them)"
    * Press "Select Running"
    * Press "Delete"
    * Close warning
    Then Box "Core-current" "does not" exist
    Then Box "Core-current 2" "does" exist
    Then Box "Core-current 3" "does" exist
    * Press "Select Items"
    * Press "(Click on items to select them)"
    * Press "Select All"
    * Press "Delete"
    * Close warning
    Then Box "Core-current" "does not" exist
    Then Box "Core-current 2" "does not " exist
    Then Box "Core-current 3" "does not" exist

  @send_keycombos
  Scenario: Send key combos
    * Create new box "Core-current"
    * Go into "Core-current" box
    * Install TC Linux package "distro.ibiblio.org/tinycorelinux/3.x/tcz/showkey.tcz" and wait "1" seconds
    * Start showkey signal recording
    * Press "Send key combinations" in "Core-current" vm
    * Press "Ctrl + Alt + Backspace" in "Core-current" vm
    * Press "Send key combinations" in "Core-current" vm
    * Press "Ctrl + Alt + F1" in "Core-current" vm
    * Press "Send key combinations" in "Core-current" vm
    * Press "Ctrl + Alt + F2" in "Core-current" vm
    * Press "Send key combinations" in "Core-current" vm
    * Press "Ctrl + Alt + F7" in "Core-current" vm
    # showkey ends automatically after 10 seconds w/o signals
    * Wait for "sleep 10" end
    * Focus VM
    # If all signals received as expected turn down network
    Then Verify previously recorded signals
    # and network should be unreachable from outside
    Then Cannot ping "Core-current"

### TBD ###
  # local_machine_paused_after_quit
  # detach_from_system_broker
  # add_machine_from_system_broker_via_url
