# -*- encoding : utf-8 -*-
class LogoUploader < Utils::CarrierWave::BaseUploader
  
  process :strip
  process :quality => 90
  
  version :thumb do
    process :resize_to_fit => [80, 80]
  end

  version :med do
    process :resize_to_fit => [115, 100]
  end

  version :tovar_200 do
    process :resize_to_fit => [200, 136]
  end

  version :company_show do
    process :resize_to_fit => [210, 210]
  end

  version :content do
    process :resize_to_fit => [575, 500]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
