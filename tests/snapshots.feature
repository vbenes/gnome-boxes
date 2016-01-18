Feature: Snapshots

  Background:
    * Make sure that gnome-boxes is running
    * Wait until overview is loaded

  @snapshots_create_an_revert
  Scenario: Create snapshots and revert to them
    * Create new box "Core-current"
    * Create snapshot "working network" from machine "Core-current"
    * Go into "Core-current" box
    * Wait for "sleep 1" end
    * Type text "sudo ifconfig eth0 down" and return
    * Press "back" in "Core-current" vm
    * Create snapshot "network down" from machine "Core-current"
    When "network down" is visible with command "virsh snapshot-current boxes-unknown |grep description"
    When Cannot ping "Core-current"
    * Revert machine "Core-current" to state "working network"
    When "working network" is visible with command "virsh snapshot-current boxes-unknown |grep description"
    When Ping "Core-current"
    * Revert machine "Core-current" to state "network down"
    Then Cannot ping "Core-current"

  @delete_snapshots
  Scenario: Delete snapshots
    * Initiate new box "Core-current" installation
    * Create snapshot "working network" from machine "Core-current"
    * Create snapshot "network down" from machine "Core-current"
    When "network down" is visible with command "virsh snapshot-current boxes-unknown |grep description"
    * Delete machines "Core-current" snapshot "working network"
    When "network down" is visible with command "virsh snapshot-current boxes-unknown |grep description"
    * Delete machines "Core-current" snapshot "network down"
    Then "network down" is not visible with command "virsh snapshot-current boxes-unknown |grep description"
    And "network down" is not visible with command "virsh snapshot-current boxes-unknown |grep description"
