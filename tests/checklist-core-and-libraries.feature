# Converted from the communitybot legacy tests by kora-qa-panel/scripts/convert-legacy.mjs.
# The """ block under each Scenario is the original test text, verbatim. Review before applying.
Feature: kora_interior — Core & Libraries

  @kora_interior @checklist @checklist:kora_interior:enter-shell-interiors @cat:core-and-libraries
  Scenario: Shell interiors load when entered
    """
    Checklist test: Enter a house/apartment/motel/garage from a housing resource: the shell (e.g. shell_v16low, modernhotel, garagem) appears around you with no missing walls.
    """
    When I manually: enter a house, apartment, motel or garage from a housing resource
    Then I confirm: the shell interior (e.g. shell_v16low, modernhotel, garagem) appears around me
    And I confirm: the shell has no missing walls
    And there should be no script errors

  @kora_interior @checklist @checklist:kora_interior:shell-exit-position @cat:core-and-libraries @manual
  Scenario: Exit point and heading correct
    """
    Checklist test: Spawn into each shell type and use the exit: you are placed at the door facing the right way and can leave.
    """
    When I manually: spawn into a shell interior of each shell type from a housing resource
    And I manually: use the exit of the shell
    Then I confirm: I am placed at the door of the shell
    And I confirm: my character faces the correct way, away from the door
    And I confirm: I can leave the shell and walk away

  @kora_interior @checklist @checklist:kora_interior:shell-despawn @cat:core-and-libraries @manual
  Scenario: Shell removed on leaving
    """
    Checklist test: Leave a shell interior: the local shell objects are removed and nothing is left floating outside.
    """
    When I manually: enter a shell interior from a housing resource
    And I manually: leave the shell interior
    Then I confirm: the local shell objects are removed
    And I confirm: nothing is left floating outside

  @kora_interior @checklist @checklist:kora_interior:geometry-exports @cat:core-and-libraries @needs:admin
  Scenario: createGeometry/removeGeometry exports
    """
    Checklist test: From a test script call exports.kora_interior:createGeometry then removeGeometry; frozen local shell appears and is released without teleporting you.
    """
    When I manually: as an admin, run /runcode with a client snippet that calls exports.kora_interior:createGeometry using a point near my position as origin, an exit offset and a bundled shell model, and keeps the returned objects in a variable
    Then I confirm: a frozen local shell appears
    And I confirm: I was not teleported
    When I manually: as an admin, run /runcode with a client snippet that calls exports.kora_interior:removeGeometry with the saved objects
    Then I confirm: the shell is released and removed
    And I confirm: I was not teleported
    And there should be no script errors
