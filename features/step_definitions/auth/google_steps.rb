When /^I click google icon, Site redirect me into google openID app$/ do
  visit root_path
  Account.find_by_uid_and_provider('google_id', 'google').should be_false
  click_on "google_btn"
  @account = Account.find_by_uid_and_provider('google_id', 'google')
  @account.should be_true
  @account.first_name = 'test'
  @account.save.should be_true
  page.should have_selector("a", text: "logout")
  click_on 'logout_link'
end

When /^I Confirmed the app$/ do
  @account.first_name = 'test'
end

Then /^I am site user because google give me email$/ do
  @account.first_name = 'test'
end