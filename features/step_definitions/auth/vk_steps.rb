When /^I click vk icon, Site redirect me into vk app and confirm vk app$/ do
  visit root_path
  page.driver.request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:vkontakte]
  Account.find_by_uid_and_provider('vk_id', 'vkontakte').should be_false
  click_on "vkontakte_btn"
  fill_in 'email_for_registration', :with => 'vkontakte@email.com'
  click_on 'enter_email_button'
  account = Account.find_by_uid_and_provider('vk_id', 'vkontakte')
  account.should be_true
  account.first_name = 'test'
  account.save.should be_true
  page.has_selector?("a", text: "logout").should be_true
  click_on 'logout_link'
end

Then /^I must write my email for auth by vk and confirm the email for registration$/ do
  pending # express the regexp above with the code you wish you had
end