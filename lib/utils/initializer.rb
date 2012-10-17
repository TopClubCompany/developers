#require 'rails'
#require 'awesome_nested_set'
#require 'inherited_resources'
#require 'sunrise-file-upload'
#require "carrierwave"

require "utils/core"
require 'elastic_adds'

include Utils

ActiveSupport::XmlMini.backend = 'Nokogiri'
InheritedResources.flash_keys = Utils.flash_keys

ActiveSupport.on_load :active_record do
  ActiveRecord::Base.send :include, Utils::Base::Mysql
  ActiveRecord::Base.send :include, Utils::CarrierWave::Glue
end

ActiveSupport.on_load :action_controller do
  ActionController::Base.send :include, Utils::Controllers::HeadOptions
end

ActiveSupport.on_load :action_view do
  ActionView::Base.send :include, Utils::Views::Helpers
  ActionView::Base.send :include, Utils::Views::AdminHelpers
end

#CollectiveIdea::Acts::NestedSet::Model.send :include, Utils::NestedSet::Depth
CollectiveIdea::Acts::NestedSet::Model.send :include, Utils::NestedSet::Descendants

ActionView::Base.field_error_proc = Utils.field_error_proc

Sunrise::FileUpload.setup do |config|
  config.base_path = Rails.root.to_s
end

Sunrise::FileUpload::Manager.before_create do |env, asset|
  asset.user = env['warden'].user if env['warden']
end

