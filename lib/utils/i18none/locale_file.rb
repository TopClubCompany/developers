module Utils
  module I18none
    class LocaleFile
      attr_accessor :file, :dir, :file_name, :locale

      def initialize(file)
        @file = file
        @dir = File.dirname(@file)
        @file_name = File.basename(@file)
        @locale = @file_name.scan(/^(?:#{Utils::I18none::LOCALES.join('|')})(?=\.)/).first
        raise Exception.new("Unknown locale #{@locale}") unless Utils::I18none::LOCALES.include?(@locale)
      end

      def locale_hash
        unless @locale_hash
          raise Exception.new("Empty file #{@file}") unless content = self.read[self.locale]
          @locale_hash = Hash.convert_hash_to_ordered_hash(content)
        end
        @locale_hash
      end

      def refresh_locale_hash
        @locale_hash = false
      end

      def locale_hash=(value)
        raise Exception.new("Not a hash #{value} for #{@file}") unless value.is_a?(Hash)
        @locale_hash = Hash.convert_hash_to_ordered_hash(value)
      end

      def save
        self.write(@locale => self.locale_hash)
      end

      def write(hash)
        File.open(@file, 'w') do |file|
          file.write hash.to_yaml.force_encoding('UTF-8')
        end #rescue false
      end

      def read
        YAML.load_file(@file).to_hash
      end
    end
  end
end
