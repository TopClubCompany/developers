# -*- encoding : utf-8 -*-
class AvatarUploader < Utils::CarrierWave::BaseUploader
  
  process :strip
  process :quality => 90
  
  version :thumb do
    process :resize_to_fill => [80, 80, 'North']
  end

  version :sidebar do
    process :resize_to_fill => [100, 100, 'North']
  end

  version :content do
    process :resize_to_limit => [300, 300]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
