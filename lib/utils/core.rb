# -*- encoding : utf-8 -*-
require 'utils/core_ext'

module Utils
  module Base
    autoload :Tiny, 'utils/base/tiny'
    autoload :Mysql, 'utils/base/mysql'
    autoload :Video, 'utils/base/mysql'
    autoload :Files, 'utils/base/files'
    autoload :IMAGE_TYPES, 'utils/base/files'
  end

  module Elastic
    autoload :ANALYZERS, 'utils/elastic/base'
    autoload :ANALYZE, 'utils/elastic/base'
  end

  module Models
    autoload :RoleType,      'utils/models/role_type'
    autoload :StructureType, 'utils/models/structure_type'
    autoload :PositionType,  'utils/models/position_type'
    autoload :Header,        'utils/models/header'
    autoload :Base,        'utils/models/base'
    autoload :TranslationAttributes,        'utils/models/translation_attributes'
  end
  
  module Controllers
    autoload :Application, 'utils/controllers/application'
    autoload :ActiveAdmin, 'utils/controllers/active_admin'
    autoload :HeadOptions, 'utils/controllers/head_options'
    autoload :TheSortableTree, 'utils/controllers/the_sortable_tree'
  end
  
  module Views
    autoload :Helpers, 'utils/views/helpers'
    autoload :FormBuilder, 'utils/views/form_builder'
    autoload :AdminHelpers, 'utils/views/admin_helpers'
    autoload :NestedSet, 'utils/views/nested_set'
  end

  module Mailers
    autoload :MailAttachHelper, 'utils/mailers/mail_attach_helper'
  end

  module NestedSet
    autoload :Descendants, 'utils/nested_set/descendants'
    autoload :Depth, 'utils/nested_set/depth'
  end

  module Sphinx
    autoload :Autocomplete, 'utils/sphinx/autocomplete'
    autoload :Translations, 'utils/sphinx/translations'
    autoload :UpdateDeltas, 'utils/sphinx/update_deltas'
  end

  module CarrierWave
    autoload :Glue, 'utils/carrier_wave/glue'
    autoload :BaseUploader, 'utils/carrier_wave/base_uploader'
    autoload :FileSizeValidator, 'utils/carrier_wave/file_size_validator'
  end

  module I18none
    autoload :LocaleFile, 'utils/i18none/locale_file'
    autoload :ModelTranslator, 'utils/i18none/model_translator'
    autoload :GoogleLanguage, 'utils/i18none/google_language'
    autoload :Translator, 'utils/i18none/translator'
  end

  # Custom flash_keys
  mattr_accessor :flash_keys
  @@flash_keys = [ :success, :failure ]
  
  mattr_accessor :available_locales
  @@available_locales = []
  
  mattr_accessor :title_spliter
  @@title_spliter = ' – '

  mattr_accessor :image_types
  @@image_types = %w(image/jpeg image/png image/gif image/jpg image/pjpeg image/tiff image/x-png)

  mattr_accessor :field_error_proc
  @@field_error_proc = Proc.new do |html_tag, instance| 
    if html_tag =~ /<(input|textarea|select)/
      errors = instance.error_message.kind_of?(Array) ? instance.error_message : [instance.error_message]
      errors.collect! { |error| "<li>#{error}</li>" } 
      message = "<ul class='error_box error_box_narrow'>#{errors.join}</ul>".html_safe
      html_tag += message
    end
    
    if html_tag =~ /<label/
      html_tag
    else
      "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
    end
  end
  
  # Default way to setup Devise. Run rails generate devise_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

  def self.load_files!(path = 'lib/utils')
    Dir[Rails.root.join("#{path}/**/*.rb")].each do |path|
      require_dependency path
    end
  end

  def self.benchmark(message = "Benchmarking", options = {})
    result = nil
    ms = Benchmark.ms { result = yield }
    Rails.logger.debug '%s (%.3fms)' % [message, ms]
    result
  end

  def self.pretty(raw_data)
    data = case raw_data
             when Hash
               raw_data
             when String
               MultiJson.decode(raw_data)
           end
    JSON.pretty_generate data
  end

  def self.val_to_array(val)
    return [] unless val
    val.is_a?(Array) ? val : val.split(',').map(&:to_i).without(0)
  end

  def self.val_to_array_s(val)
    return [] unless val
    val.is_a?(Array) ? val : val.split(',').map(&:to_s).without(0)
  end

end