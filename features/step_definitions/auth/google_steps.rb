When /^I click google icon, Site redirect me into google openID app$/ do
  visit root_path
  page.driver.request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
  Account.find_by_uid_and_provider('google_id', 'google').should be_false
  click_on "google_btn"
  @account = Account.find_by_uid_and_provider('google_id', 'google')
  @account.should be_true
  @account.first_name = 'test'
  @account.save.should be_true
  page.should have_selector("a", text: "logout")
  click_on 'logout_link'
end

When /^I Confirmed the google app$/ do
  #puts @account.email
  @account.first_name.should eq 'test'
end

Then /^I am site user because google give me email$/ do
  #puts @account.email
  @account.email.should eq 'google@haha.com'
end