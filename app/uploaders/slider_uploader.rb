class SliderUploader < Utils::CarrierWave::BaseUploader
  process :strip
  process :crop
  process :quality => 90

  version :thumb do
    process :resize_to_fill => [80, 80]
  end


  version :content do
    process :resize_to_fit => [575, 500]
  end

  version :main do
    process :resize_to_fill => [1600, 571]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end