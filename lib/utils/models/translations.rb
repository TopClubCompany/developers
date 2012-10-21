module Utils
  module Models
    module Translations
      extend ActiveSupport::Concern

      included do
        class_eval do
          ::I18n.available_locales.each do |loc|
            has_one "translation_#{loc}".to_sym, :class_name => translation_class.name,
                    :foreign_key => class_name.foreign_key, :conditions => {:locale => loc.to_s}
          end
        end
      end

    end
  end
end