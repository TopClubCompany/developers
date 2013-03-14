require File.expand_path('../yaml_waml', __FILE__)

module Utils
  module I18none
    LOCALES = Globalize.available_locales.map(&:to_s)

    class Translator
      attr_accessor :locale_files, :message, :main_locale, :locales

      def initialize(dirs, main_locale)
        @main_locale = main_locale
        @locale_files = dirs.reject { |f| File.extname(f) != '.yml' }.map { |y| LocaleFile.new(y) }
        @locale_files.delete_if{|file| deleted_locators.include?(file.file_name)}
        @locales = {}
      end

      def deleted_locators
        %w(en.date.yml ru.date.yml ua.date.yml en.admin_js.yml ru.admin_js.yml ua.admin_js.yml)
      end

      def self.prepare_from_env
        obj = from_env
        obj.initialize_files
      end

      def self.from_env
        locale = I18n.default_locale.to_s
        locale_filenames = reject_not_from_config_lib(I18n.load_path)
        new(locale_filenames, locale)
      end

      def get_by_file(file_id, key=false)
        file = @locale_files[file_id]
        raise Exception.new("No file found #{file_id}") unless file
        key ? file.locale_hash.fetch_keys(*key.split('.')) : file.locale_hash
      rescue
        ''
      end

      def get_main_by_file(file_id, key=false)
        file = @locale_files[file_id]
        main_file_full_name = [file.dir, file.file_name.sub(/^#{file.locale}/, @main_locale)].to_param
        main_file = @locale_files.detect { |f| f.file == main_file_full_name }
        raise Exception.new("No file found #{file_id}") unless main_file
        key ? main_file.locale_hash.fetch_keys(*key.split('.')) : main_file.locale_hash
      rescue
        ''
      end

      def get_by_locale(locale, key=false)
        raise Exception.new("Locale not found #{locale}") unless Utils::I18none::LOCALES.include?(locale)
        @locales[locale] = set_locale_hash(locale) unless @locales[locale]
        key ? @locales[locale].fetch_keys(*key.split('.')) : @locales[locale]
      rescue
        ''
      end

      def set_by_file(file_id, value, key=false)
        file = @locale_files[file_id]
        raise Exception.new("No file found #{file_id}") unless file
        key ? file.locale_hash.set_keys(value, *key.split('.')) : file.locale_hash = value
        file.write({file.locale => file.locale_hash})
      rescue
        raise Exception.new("Error set key: #{key} value: #{value} file: #{file_id}")
      end

      def initialize_files
        files_by_locale = @locale_files.group_by(&:locale)
        files_by_locale[@main_locale].each do |main_file|
          main_file.save
          Utils::I18none::LOCALES.each do |locale|
            main_file_clear_hash = main_file.locale_hash.deep_clear_values
            next if locale == @main_locale

            curr_file_name = main_file.file_name.sub(/^#{@main_locale}/, locale)
            curr_full_file_name = File.join(main_file.dir, curr_file_name)
            curr_file = files_by_locale[locale].detect { |f| f.dir == main_file.dir && f.file_name == curr_file_name }

            if files_by_locale[locale] && curr_file
              curr_file.locale_hash = Hash.convert_hash_to_ordered_hash(main_file_clear_hash.deep_add(curr_file.locale_hash))
            else
              curr_file = LocaleFile.new(curr_full_file_name)
              @locale_files << curr_file
              @message = "Reload application to load new locale files"
              curr_file.locale_hash = main_file_clear_hash
            end

            raise Exception.new("Can't write into file #{curr_full_file_name}") unless curr_file.save
            main_file.refresh_locale_hash
          end
        end
        self
      end

      def save_locale_files
        @locale_files.each do |f|
          raise Exception.new("Error saving file#{f.file}") unless f.write({f.locale => f.locale_hash})
        end
        self
      end

#  protected

      def set_locale_hash(locale)
        files = get_locale_filenames(locale).map(&:locale_hash)
        files.deep_merge_hashes
      end

      def get_locale_filenames(locale)
        @locale_files.find_all { |f| f.locale == locale }
      end

      def self.reject_not_from_config_lib(files)
        good_paths = [Rails.root.join('config')].join('|')
        bad_paths = [Rails.root.join('lib/utils/locales')].join('|')
        files.map { |f| File.expand_path(f) }.find_all { |f| f =~ /^(#{good_paths})\// }.reject { |f| f =~ /^(#{bad_paths})\// }
      end
    end

  end
end