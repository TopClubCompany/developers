# -*- encoding : utf-8 -*-
class PhotoUploader < Utils::CarrierWave::BaseUploader
  
  process :strip
  process :crop
  process :quality => 90

  version :thumb do
    process :resize_to_fill => [80, 80]
    #process :watermark => Rails.root.join('public/images/rails.png').to_s
  end

  version :content do
    process :resize_to_fill => [518, 211]
  end

  version :large do
    process :resize_to_limit => [600, 600]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
