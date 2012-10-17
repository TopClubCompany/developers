# -*- encoding : utf-8 -*-
module Utils
  module Models
    module Base
      extend ActiveSupport::Concern

      included do
        begin
          if column_names.include?('import_id')
            attr_accessible :import_id
          end

          if translates?
            default_scope includes(:translations)
            include Utils::Models::TranslationAttributes
            attr_accessible *all_translated_attribute_names
            scope :with_translation, lambda { joins("translation_#{I18n.locale}".to_sym) }
            #scope :active_admin, with_translation
          end
          scope :admin, scoped

          if column_names.include?('is_visible')
            scope :visible, where(:is_visible => true)
            scope :un_visible, where(:is_visible => false)
            if column_names.include?('published_at')
              scope :published, visible.where("#{quoted_table_name}.published_at <= NOW()")
              scope :recently, visible.order("#{quoted_table_name}.published_at DESC")
            else
              scope :recently, visible.order("#{quoted_table_name}.created_at DESC")
            end
          end

          if column_names.include?('is_ready')
            scope :ready, where(:is_ready => true)
          end

          scope :latest, order("#{quoted_table_name}.created_at DESC")

          if column_names.include?('user_id')
            scope :created_by, proc { |user_id| where(:user_id => user_id) }
          end

          if column_names.include?('slug')
            extend FriendlyId
            #if column_names.include?('alias') || translated_attribute_names.include?(:alias)
            #  friendly_id :alias, :use => :slugged
            if column_names.include?('name') || translated_attribute_names.include?(:name)
              friendly_id :name, :use => :slugged
            elsif column_names.include?('title') || translated_attribute_names.include?(:title)
              friendly_id :title, :use => :slugged
            end
          end

          new.instance_eval do
            if !methods.include?(:title) && methods.include?(:name)
              self.class.alias_attribute :title, :name
            end

            if !methods.include?(:name) && methods.include?(:title)
              self.class.alias_attribute :name, :title
            end
          end

          include Utils::Models::BaseAddition
        end rescue false
      end

      module ClassMethods
        def find_by_permalink(value)
          return if value.blank?
          value.to_s.is_int? ? where(:id => value.to_i).first : where(:slug => value.to_s).first
        end

        def find_by_permalink!(value)
          record = find_by_permalink(value)
          raise ActiveRecord::RecordNotFound, "Couldn't find structure by #{value}" if record.nil?
          record
        end

      end

      def fast_tag_names
        Tag::Translation.where(:tag_id => tags.value_of(:id), :locale => I18n.locale.to_s).value_of :name
      end

      def make_slug
        if self.class.respond_to?(:friendly_id_config)
          instance_eval { set_slug }
        end
      end

      def user_for_paper_trail
        user_signed_in? ? current_user : 'Unknown user'
      end

      def should_generate_new_friendly_id?
        new_record?
      end

      #def add_image(assoc, path)
      #  if klass = self.class.reflect_on_association(assoc).try(:klass)
      #    img = klass.new
      #    img.assetable = self
      #    File.open(path) { |f| img.data = f }
      #    img.save
      #  end
      #end

      def add_image(assoc, path)
        if new_record?
          add_image_new_record(assoc, path) and return
        end
        assoc_obj = self.class.reflect_on_association(assoc)
        if klass = assoc_obj.try(:klass)
          img = klass.new
          img.is_main = !assoc_obj.collection?
          img.assetable = self
          File.open(path) { |f| img.data = f }
          img.save
        end
      end

      def add_image_new_record(assoc, path)
        assoc_obj = self.class.reflect_on_association(assoc)
        if klass = assoc_obj.try(:klass)
          img = klass.new
          img.is_main = !assoc_obj.collection?
          img.assetable_type = self.class.name
          img.assetable_id = 0
          img.guid = fileupload_guid
          File.open(path) { |f| img.data = f }
          img.save
        end
      end

      def for_input_token
        {id: id, name: name}
      end

      def get_translation_hash(property="name")
        translation_properties = {}
        ::I18n.available_locales.each do |locale|
          translation_properties.update(locale => self.send("#{property}_#{locale}"))
        end
        translation_properties
      end

      def get_assets(assoc_name)
        return [] unless assoc_name.present?
        assoc = self.class.reflect_on_association(assoc_name.to_sym)
        if assoc
          assoc.collection? ? send(assoc_name).includes(:translations) : send(assoc_name)
        else
          []
        end
      end

      #def normalize_friendly_id(string)
      #  "#{id}-#{super}"
      #end
    end
  end
end
