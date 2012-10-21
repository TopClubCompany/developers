require "fileutils"

module Utils
  module Base
    #IMAGE_TYPES = %w(image/jpeg image/png image/gif image/jpg image/pjpeg image/tiff image/x-png)

    module Files

      def self.parameterize_filename(filename)
        extension = File.extname(filename)
        basename = filename.gsub(/#{extension}$/, "")

        [basename.parameterize('_'), extension].join.downcase
      end

      def self.clear_cache
        Rails.cache.clear
        FileUtils.rm_r(Dir.glob(Rails.root.join('public', 'cache', '*').to_s), :force => true)
      end

    end
  end
end