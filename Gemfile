source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem 'mysql2'
gem 'redis'
gem 'haml'
gem 'slim'
gem 'styx'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  #gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'ffaker'
gem 'machinist'

gem 'geokit'
gem 'geokit-rails3'
gem 'geokit-nominatim'#, :git => 'git://github.com/sobakasu/geokit-nominatim.git'
gem 'tire'


#authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'cancan'

gem 'kaminari'
gem 'unicode_utils' # For unicode-strings downcase method o_O !!!
gem 'unicorn'

group :development do
  gem 'annotate'#, :git => 'git://github.com/vlado/annotate_models.git', :ref => '562970b'
end


gem 'twitter-bootstrap-rails'
gem "bootstrap-sass", ">= 2.0.3"
gem "simple_form"
gem "will_paginate", ">= 3.0.3"
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-timepicker-rails'
gem 'will_paginate-bootstrap'
gem 'the_sortable_tree', '~> 1.8.0'
gem 'inherited_resources', '~> 1.3.0'
gem 'therubyracer', '~> 0.10.2'


#AR
gem 'has_scope'
gem 'awesome_nested_set'
gem 'galetahub-enum_field', "~> 0.2.0", :require => 'enum_field'
gem 'activerecord-import'

group :development, :test do
  if RUBY_PLATFORM.downcase.include?("darwin")
    gem 'rb-fsevent', '~> 0.9.1'
    gem 'terminal-notifier-guard'
    gem 'growl'
    gem 'growl_notify'
  end

  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem "rspec-rails", ">= 2.10.1"
  gem "factory_girl_rails", ">= 3.3.0"
  gem "factory_girl", '>=4.0.0'
  gem 'quiet_assets'
  gem 'forgery', '0.3.12'
  gem 'jasmine-rails'
  gem "guard-rspec"
  gem "capybara"
  gem 'cucumber-rails', :require => false
  gem "spork"
  gem 'guard-spork'
  gem 'guard-coffeescript'
  gem 'rb-inotify' if RUBY_PLATFORM.downcase.include?("linux")
  gem 'guard-livereload'
  gem 'guard-jasmine'
  gem 'jasminerice'
end
