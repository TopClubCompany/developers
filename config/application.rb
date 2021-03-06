require File.expand_path('../boot', __FILE__)
require 'rails/all'
if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end
module Ckeditor; def self.assets; []; end; end if File.exists?(File.expand_path('../../public/assets/ckeditor/config.js', __FILE__))


module Topclub
  class Application < Rails::Application
    config.middleware.use Rack::Pjax
    config.generators do |g|
      g.test_framework :rspec
      g.template_engine :slim
    end

    # don't generate RSpec tests for views and helpers
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      # rails generate controller controller_name --assets=false
      g.stylesheets = false
      g.javascripts = false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/app/models/type_models
                                #{config.root}/app/models/user_models
                                #{config.root}/app/models/asset_models
                                #{config.root}/app/models/defaults
                                #{config.root}/lib
                                #{config.root}/app/models/friend_models)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru
    config.active_record.default_timezone = :local

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true
    # back
    config.assets.precompile += %w(admin/application.js jquery.ui.nestedSortable.js admin/components/permissions.js ckeditor/init.js)

    config.assets.precompile += %w(admin/application.css nested_set.css the_sortable_tree.css)

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    config.assets.precompile += Ckeditor.assets

  end
end
module Ckeditor; def self.assets; []; end; end if File.exists?(Rails.root.join('public/assets/ckeditor/config.js'))
