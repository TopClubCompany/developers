# -*- encoding : utf-8 -*-'

Given /^I click facebook icon then Site redirect me into facebook app where i confirmed app$/ do
  visit root_path
  @account = Account.find_by_uid_and_provider('fb_id', 'facebook').should be_false
  click_on "facebook_btn"
  @account = Account.find_by_uid_and_provider('fb_id', 'facebook')
  @account.should be_true
  @account.first_name = 'test'
  @account.save.should be_true
  page.should have_selector("a", text: "logout")
  click_on 'logout_link'
end

Then /^I am site user because facebook give me email$/ do
  @account.email.should eq 'facebook@haha.com'
end

Then /^I have nick_name, email, avatar$/ do
  @account.first_name = 'test'
end