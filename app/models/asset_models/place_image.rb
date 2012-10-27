class PlaceImage < Asset
  sunrise_uploader PlaceImageUploader

  validates :data_content_type, :inclusion => {:in => Utils.image_types }
  validates_integrity_of :data
  validates_filesize_of :data, :maximum => 10.megabyte

end# == Schema Information
#
# Table name: assets
#
#  id                :integer          not null, primary key
#  data_file_name    :string(255)      not null
#  data_content_type :string(255)
#  data_file_size    :integer
#  assetable_id      :integer          not null
#  assetable_type    :string(25)       not null
#  type              :string(25)
#  guid              :string(10)
#  locale            :integer          default(0)
#  user_id           :integer
#  sort_order        :integer          default(0)
#  is_main           :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_assets_on_assetable_type_and_assetable_id           (assetable_type,assetable_id)
#  index_assets_on_assetable_type_and_type_and_assetable_id  (assetable_type,type,assetable_id)
#  index_assets_on_user_id                                   (user_id)
#

