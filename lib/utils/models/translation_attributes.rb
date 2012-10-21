module Utils
  module Models
    module TranslationAttributes
      extend ActiveSupport::Concern

      included do
        def changed_attributes_with_translations
          old_h = changed_attributes_without_translations.stringify_keys
          old_h.update(changed_translations).except(*self.class.translated_attribute_names.map(&:to_s))
        end

        alias_method_chain :changed_attributes, :translations
      end

      def versioned_attributes
        attributes.update(changed_attributes).slice(*self.class.versioned_columns)
      end

      def changed_translations
        globalize.stash.each_with_object({}).each do |(k, v), h|
          v.each do |kk, vv|
            h["#{kk}_#{k}"] = translation_for(k)[kk]
          end
        end
      end

      #def all_stale_translated_attributes
      #  ::I18n.available_locales.each_with_object({}) do |loc, h|
      #    self.class.translated_attribute_names.map(&:to_s).each do |attr|
      #      h["#{attr}_#{loc}"] = translation_for(loc)[attr]
      #    end
      #  end
      #end
      #
      #def all_translated_attributes
      #  self.class.all_translated_attribute_names.each_with_object({}) { |a, h| h[a.to_s] = self.send(a) }
      #end

      module ClassMethods

        def versioned_columns
          all_columns_names.without('id', 'created_at', 'updated_at')
        end

        def all_column_names
          @all_column_names ||= begin
            if translates?
              column_names + translated_attribute_names.map(&:to_s)
            else
              column_names
            end
          end
        end

      end
    end
  end
end
