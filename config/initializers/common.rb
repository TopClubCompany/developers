# -*- encoding : utf-8 -*-
require 'utils/initializer'
require 'yajl/json_gem'
require "i18n/backend/fallbacks"
require "simple_form_hooks"

#require 'resque_scheduler'
#require 'resque_scheduler/server'
#Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))

Rails.cache.silence!
Responders::FlashResponder.flash_keys = [:notice, :error]
#Responders::FlashResponder.flash_keys = [:success, :failure]
Responders::FlashResponder.namespace_lookup = true

MultiJson.engine = :yajl

$redis ||= Redis.new

I18n.available_locales = Globalize.available_locales = [:ru, :en, :uk]
I18n.locale = Rails.application.config.i18n.default_locale
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n.fallbacks.map(:uk => :en, :en => :ru)
module ActionView
  module Helpers
    class InstanceTag
      DEFAULT_TEXT_AREA_OPTIONS = { :cols => 93, :rows => 5 }.freeze unless const_defined?(:DEFAULT_TEXT_AREA_OPTIONS)
    end
  end
end

#ActionView::Base::InstanceTag::DEFAULT_TEXT_AREA_OPTIONS = {"cols" => 93, "rows" => 5}

RoutingFilter::Locale.include_default_locale = false

module Utils
  mattr_accessor :elastic_prefix
end
#Utils.fb_logger = Utils::Base::Logger.for_file(Rails.root.join('log', 'fb.log'))
Utils.elastic_prefix = 'top_club'

Utils.setup do |config|
  # Flash keys
  #config.flash_keys = [ :success, :failure ]
end

Time::DATE_FORMATS[:api] = "%d.%m.%Y"
Time::DATE_FORMATS[:compare] = '%Y%m%d%H%M'
Time::DATE_FORMATS[:compare_date] = '%Y%m%d'

module Globalize
  mattr_accessor :available_locales

  def self.valid_locale?(loc)
    return false unless loc
    available_locales.include?(loc.to_sym)
  end
end

ActiveRecord::Base.class_eval do
  #include Utils::Models::MissingAttributes
  include Utils::Models::DeepCloneable
  include Utils::Models::ArExt
  include Utils::Elastic::Autocomplete
  include Utils::Models::TokenIds
  include Utils::Models::AsBitMask
  include Utils::Models::Silencer
  extend Utils::Models::Silencer
end

#ActionMailer::Base.class_eval do
#  include Utils::Mailers::MailAttachHelper
#  #include Resque::Mailer
#end

if Rails.env.production?
  module ActionDispatch
    class Request
      def local?
        false
      end
    end
  end
end

require 'htmlentities'
class String
  def no_html
    str = self.dup
    str.gsub!(/<\/?[^>]*>/, '')
    str.strip!
    str.gsub!('&nbsp;', '')
    str
  end

  def clean_text
    coder = HTMLEntities.new
    coder.decode(self.no_html)
  end
end


#module VK
#  class Serverside
#    include Core
#    include Transformer
#
#    attr_accessor :app_secret, :settings
#
#    def initialize(p={})
#      p.each { |k, v| instance_variable_set(:"@#{k}", v) }
#      raise 'undefined application id' unless @app_id
#      raise 'undefined application secret' unless @app_secret
#
#      @settings ||= 'notify,friends,offline'
#
#      transform base_api, self.method(:vk_call)
#    end
#
#    def authorize(opts={}, auto_save = true)
#      result = opts
#      result.each { |k, v| instance_variable_set(:"@#{k}", v) } if auto_save
#      result
#    end
#  end
#end

if Rails.env.development? && false
  module CarrierWave
    module Uploader
      module Versions

        def full_filename(for_file)
          "#{version_name || model.created_at.to_i}_#{super(for_file).sub("#{model.created_at.to_i.to_s}_", '')}"
        end

        def full_original_filename
          "#{version_name || model.created_at.to_i}_#{super.sub("#{model.created_at.to_i.to_s}_", '')}"
        end

      end
    end
  end
end
