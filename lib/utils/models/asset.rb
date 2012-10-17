# -*- encoding : utf-8 -*-

module Utils
  module Models
    module Asset
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.class_eval do
            belongs_to :user
            belongs_to :assetable, :polymorphic => true
    
            #before_validation :make_content_type
            #before_create :read_dimensions
            
            delegate :url, :original_filename, :to => :data
            alias :filename :original_filename
          end
        end
        
        def move_to(index, id)
          update_all(["sort_order = ?", index], ["id = ?", id.to_i])
        end
      end
      
      module InstanceMethods

        def file_css_class
          MIME::Type.new(data_content_type).try(:sub_type).gsub('.', '_')
        end

        def dimensions_color
          'grey'
        end

        def preview_url
          data.url
        end

        def thumb_url
          data.url(self.class.thumb_size) if image?
        end

        def format_created_at
          I18n.l(created_at, :format => "%d.%m.%Y %H:%M")
        end
        
        def to_xml(options = {}, &block)
          options = {:only => [:id], :root => 'asset'}.merge(options)
          
          options[:procs] ||= Proc.new do |options, record| 
            options[:builder].tag!('filename', filename)
            options[:builder].tag!('path', url)
            options[:builder].tag!('size', data_file_size)
          end
          
          super
        end
        
        def as_json(options = nil)
          options = {
            :only => [:id, :guid, :assetable_id, :assetable_type, :user_id, :data_file_size, :data_content_type, :is_main],
            :root => 'asset',
            :methods => [:filename, :url, :preview_url, :thumb_url, :width, :height, :dimensions_color, :file_css_class]
          }.merge(options || {})
          
          super
        end
        
        def has_dimensions?
          respond_to?(:width) && respond_to?(:height)
        end
        
        def image?
          Utils.image_types.include?(self.data_content_type)
        end

        def get_translation_hash(property="name")
          translation_properties = {}
          ::I18n.available_locales.each do |locale|
            translation_properties.update(locale => self.send("#{property}_#{locale}"))
          end
          translation_properties
        end

        
      end
    end
  end
end
