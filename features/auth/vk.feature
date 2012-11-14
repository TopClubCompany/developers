Feature: Sing in vk
  Scenario: Use vk account for registration
    When I click vk icon, Site redirect me into vk app and confirm vk app
    Then I must write my email for auth by vk and confirm the email for registration
    Then I am a site user because I give my email and confirm for email

  Scenario:
    Given I logout from system and then I click vk icon for registration
    Then I login as vk user and system don't redirect me to vk page