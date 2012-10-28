source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem 'mysql2'
gem 'redis'
gem 'slim'
gem 'styx'

gem 'globalize3', :git => 'git://github.com/leschenko/globalize3.git', :ref => '586ccbd'


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
gem 'devise-encryptable'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'cancan'

#gem 'kaminari'
gem 'unicode_utils' # For unicode-strings downcase method o_O !!!

group :development do
  if File.exists?('/var/www/top_club/developers/.local_gems')
    gem 'annotate', :path => '/var/www/gems/annotate_models'
  else
    gem 'annotate', :git => 'git://github.com/OpakAlex/annotate_models.git', ref: '568b3b4a76'
  end
end


gem 'twitter-bootstrap-rails'#, :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', :ref => '86cffd5'
gem "bootstrap-sass", ">= 2.0.3"
gem "simple_form"
gem "will_paginate", ">= 3.0.3"
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-timepicker-rails'

#Advance
gem 'configatron'
gem 'will_paginate-bootstrap'
gem 'the_sortable_tree', '~> 1.8.0'
gem 'inherited_resources', '~> 1.3.0'
gem 'therubyracer', '~> 0.10.2'
gem 'carrierwave'
gem 'mini_magick'
gem 'ckeditor'
gem 'yajl-ruby'
gem 'multi_json'
gem "nested_form"
gem 'htmlentities'
gem 'routing-filter'

#I18n
gem 'i18n-js'
gem 'i18n'

#AR
gem 'has_scope'
gem 'awesome_nested_set'
gem 'galetahub-enum_field', "~> 0.2.0", :require => 'enum_field'
gem 'activerecord-import'
gem 'friendly_id'
gem "squeel"
gem "activevalidators", "~> 1.9.0"
gem 'valium'
gem "rack-pjax"
gem "ransack"

#servers
gem 'thin'
gem 'unicorn'

#gem 'rmagick'
gem 'active_link_to'
gem 'truncate_html'
#gem 'browser'
#gem 'geocoder'
#gem 'geoip'
gem 'auto_html'
#gem 'ancestry

#for uploads
gem 'sunrise-file-upload', :git => 'git://github.com/leschenko/sunrise-file-upload.git', :ref => '4d4722c'

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
  gem 'capybara-webkit'
  gem 'cucumber-rails', :require => false
  gem "spork"
  gem 'guard-spork'
  gem 'guard-coffeescript'
  gem 'rb-inotify' if RUBY_PLATFORM.downcase.include?("linux")
  gem 'guard-livereload'
  gem 'guard-jasmine'
  gem 'jasminerice'
end
