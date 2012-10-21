module Globalize
  module ActiveRecord
    module InstanceMethods
      def translation_for(locale)
        @translation_caches ||= {}
        unless @translation_caches[locale]
          # Fetch translations from database as those in the translation collection may be incomplete
          _translation = translations.detect { |t| t.locale.to_s == locale.to_s }
          @translation_caches[locale] = _translation
        end
        @translation_caches[locale]
      end
    end
  end
end
