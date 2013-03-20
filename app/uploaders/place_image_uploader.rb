class PlaceImageUploader < Utils::CarrierWave::BaseUploader

  process :strip
  process :crop
  process :quality => 90

  version :thumb do
    process :resize_to_fill => [80, 80]
  end

  version :share_fancy do
    process :resize_to_fill => [120, 80]
  end

  version :content do
    process :resize_to_fit => [575, 500]
  end

  version :slider do
    process :resize_to_fill => [140, 100]
  end

  version :main do
    process :resize_to_fill => [300, 165]
  end

  version :place_show do
    process :resize_to_fill => [240, 180]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end


end