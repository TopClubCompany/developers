class CategoryImage < Asset
  sunrise_uploader CategoryImageUploader

  validates :data_content_type, :inclusion => {:in => Utils.image_types }
  validates_integrity_of :data
  validates_filesize_of :data, :maximum => 10.megabyte

end