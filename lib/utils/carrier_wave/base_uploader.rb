# -*- encoding : utf-8 -*-
require 'mime/types'
require 'mini_magick'

module Utils
  module CarrierWave
    class BaseUploader < ::CarrierWave::Uploader::Base
      include ::CarrierWave::MiniMagick
            
      storage :file
      
      process :set_content_type
      process :set_size
      process :set_width_and_height


      # default store assets path
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{model.id}"
      end
       
      # process :strip
      def strip
        manipulate! do |img|
          img.strip
          img = yield(img) if block_given?
          img
        end
      end
      
      # process :quality => 85
      def quality(percentage)
        manipulate! do |img|
          img.quality(percentage.to_s)
          img = yield(img) if block_given?
          img
        end
      end
      
      def default_url
        "/images/defaults/#{model.class.to_s.underscore}_#{version_name}.png"
      end
      
      def set_content_type
        type = file.content_type == 'application/octet-stream' || file.content_type.blank? ? MIME::Types.type_for(original_filename).first.to_s : file.content_type
         
        model.data_content_type = type
      end 
      
      def set_size
        model.data_file_size = file.size
      end
      
      def set_width_and_height
        if model.image? && model.has_dimensions?
          magick = ::MiniMagick::Image.new(current_path)
          model.width, model.height = magick[:width], magick[:height]
        end
      end

      def crop
        manipulate! do |img|
          return img if model.crop_attrs.blank?
          img.crop "#{model.crop_attrs['w']}x#{model.crop_attrs['h']}+#{model.crop_attrs['x']}+#{model.crop_attrs['y']}"
          img
        end
      end

      def watermark(path_to_file)
        manipulate! do |img|
          logo = ::MiniMagick::Image.open(path_to_file)
          img.composite(logo) { |c| c.gravity "SouthEast" }
        end
      end

      def image?
        model.image?
      end
    end
  end
end
