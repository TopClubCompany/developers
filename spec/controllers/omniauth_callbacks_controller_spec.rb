# -*- encoding : utf-8 -*-'
require 'spec_helper'

describe Users::OmniauthCallbacksController do

  before do
    #request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end
  before (:each) do
    visit root_path
  end
  it 'should register user from vk' do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:vkontakte]
    Account.find_by_uid_and_provider('vk_id', 'vkontakte').should be_false
    click_on "vkontakte_btn"
    #response.should redirect_to
    #page.should have_selector("a", text: "Журнал")
    fill_in 'email_for_registration', :with => 'vkontakte@email.com'
    click_on 'enter_email_button'
    account = Account.find_by_uid_and_provider('vk_id', 'vkontakte')
    puts account.email
    account.should be_true
    account.first_name = 'test'
    account.save.should be_true
    page.has_selector?("a", text: "logout").should be_true
    click_on 'logout_link'
  end

  it 'should register new user from facebook' do
    #visit root_path
    #puts page.html
    #puts page.current_url
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    Account.find_by_uid_and_provider('fb_id', 'facebook').should be_false
    click_on "facebook_btn"
    account = Account.find_by_uid_and_provider('fb_id', 'facebook')
    account.should be_true
    account.first_name = 'test'
    account.save.should be_true
    page.should have_selector("a", text: "logout")
    click_on 'logout_link'
  end

  it 'should only sign in if facebook user already exist' do
    #visit root_path
    click_on "facebook_btn"
    account = Account.find_by_uid_and_provider('fb_id', 'facebook')
    account.first_name.should eq 'test'
    click_on 'logout_link'
  end


  it 'should register new user from google' do
    #visit root_path
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
    Account.find_by_uid_and_provider('google_id', 'google').should be_false
    click_on "google_btn"
    account = Account.find_by_uid_and_provider('google_id', 'google')
    account.should be_true
    account.first_name = 'test'
    account.save.should be_true
    page.should have_selector("a", text: "logout")
    click_on 'logout_link'
  end

  it 'should only sign in if google user already exist' do
    #visit root_path
    click_on "google_btn"
    account = Account.find_by_uid_and_provider('google_id', 'google')
    account.first_name.should eq 'test'
    click_on 'logout_link'
  end



  #it 'should visit email path and have form tag' do
  #  request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:vkontakte]
  #  visit enter_email_path
  #  puts page.html
  #  fill_in 'email_for_registration', :with => 'vkontakte@email.com'
  #end



  it 'should only sign in if vkontakte user already exist' do
    #visit root_path
    click_on "vkontakte_btn"
    account = Account.find_by_uid_and_provider('vk_id', 'vkontakte')
    account.first_name.should eq 'test'
    click_on 'logout_link'
  end
end