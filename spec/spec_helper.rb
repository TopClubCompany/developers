require 'rubygems'
require 'spork'

Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  Dir[Rails.root.join('spec/test/*.rb')].each{|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{Rails.root}/spec/fixtures"
    #config.use_transactional_fixtures = true
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end
    config.before(:all) do
      DatabaseCleaner.start
    end

    config.after(:all) do
      DatabaseCleaner.clean
    end
    ActiveSupport::Dependencies.clear
  end

  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:facebook, {
      info:  { name: "Facebook Smith", nickname: 'joesmith', email: 'facebook@haha.com', uid: 'fb_id' },
      extra: {raw_info: { name: "Facebook Smith" } }})
  OmniAuth.config.add_mock(:google, {
      info:  { name: "Google Smith", nickname: 'joesmith', email: 'google@haha.com', uid: 'google_id' },
      extra: {raw_info: { name: "Google Smith" } }})
  OmniAuth.config.add_mock(:vkontakte, {
      info:  { name: "Vkontakte Smith", nickname: 'joesmith', uid: 'vk_id' },
      extra: {raw_info: { name: "Joe Smith" } }})
  OmniAuth.config.add_mock(:twitter, {
      info:  { name: "Twitter Smith", nickname: 'joesmith', uid: 'tw_id' },
      extra: {raw_info: { name: "Twitter Smith" } }})
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end
  load "#{Rails.root}/config/routes.rb"
  #Dir["#{Rails.root}/lib/utils**/*.rb"].each {|f| load f}
  Dir["#{Rails.root}/app/**/*.rb"].each {|f| load f}

  Dir[Rails.root.join('spec/test/*.rb')].each{|f| require f}
  FactoryGirl.reload
end
