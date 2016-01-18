Feature: Multi Window

  Background:
    * Make sure that gnome-boxes is running
    * Wait until overview is loaded

  @open_in_new_window
  Scenario: Open box in new window
    * Initiate new box "Core-current" installation
    * Select "Core-current" box
    * Press "Open in new window"
    * Wait for "sleep 2" end
    Then Boxes app has "2" windows
    Then Verify back button "is not" visible for machine "Core-current"

  @poweroff_in_new_window
  Scenario: Poweroff in new window
    * Create new box "Core-current"
    * Select "Core-current" box
    * Press "Open in new window"
    * Wait for "sleep 2" end
    * Type text "sudo poweroff" and return
    * Wait for "sleep 20" end
    Then Boxes app has "1" windows

  @open_three_new_windows
  Scenario: Open three new windows
    * Create new box "Core-current"
    * Create new box "Core-current 2" from "Core-current" menuitem
    * Create new box "Core-current 3" from "Core-current" menuitem
    * Select "Core-current" box
    * Select "Core-current 2" box
    * Select "Core-current 3" box
    * Open "Core-current, Core-current 2, Core-current 3" in new windows
    Then Boxes app has "4" windows
    Then Verify back button "is not" visible for machine "Core-current"
    Then Verify back button "is not" visible for machine "Core-current 2"
    Then Verify back button "is not" visible for machine "Core-current 3"
    When Ping "Core-current"
    When Ping "Core-current 2"
    When Ping "Core-current 3"
    * Focus "Core-current" window
    * Type text "sudo ifconfig eth0 down" and return
    * Focus "Core-current 2" window
    * Type text "sudo ifconfig eth0 down" and return
    * Focus "Core-current 3" window
    * Type text "sudo ifconfig eth0 down" and return
    Then Cannot ping "Core-current"
    Then Cannot ping "Core-current 2"
    Then Cannot ping "Core-current 3"
