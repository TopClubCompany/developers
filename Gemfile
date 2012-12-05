source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem 'mysql2'
gem 'redis'
gem 'slim-rails'
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

gem 'geokit'
gem 'geokit-rails3'
gem 'geokit-nominatim'#, :git => 'git://github.com/sobakasu/geokit-nominatim.git'
gem 'tire'
gem 'figaro'

#authentication && social
gem 'devise'
gem 'devise-encryptable'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'omniauth-openid'
gem 'omniauth-google-oauth2'
gem 'cancan'
gem 'fb_graph'

#gem 'kaminari'
gem 'unicode_utils' # For unicode-strings downcase method o_O !!!

group :development do
  if File.exists?('/var/www/top_club/developers/.local_gems')
    gem 'annotate', :path => '/var/www/gems/annotate_models'
  else
    gem 'annotate', :git => 'git://github.com/OpakAlex/annotate_models.git', :ref => '887923f'
  end
  gem 'pry-rails'
  gem 'pry-doc'
end


gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'less-rails'
gem "bootstrap-sass"
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
gem 'geocoder'
gem 'geoip'
gem 'auto_html'
gem 'jbuilder'
#gem 'ancestry

gem 'curb'

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

  gem 'quiet_assets'
  gem 'jasmine-rails'
  gem "capybara"
  gem 'capybara-webkit', '0.12.1'
  gem 'cucumber-rails', :require => false
  gem "spork"
  gem "guard-rspec"
  gem 'guard-spork'
  gem 'guard-coffeescript'
  gem 'guard-cucumber'
  gem 'guard-livereload'
  gem 'guard-jasmine'
  gem 'jasminerice'
  gem 'rb-inotify' if RUBY_PLATFORM.downcase.include?("linux")
end

#for seed in production
gem "factory_girl_rails", ">= 3.3.0"
gem "factory_girl", '>=4.0.0'
