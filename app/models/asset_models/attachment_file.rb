# -*- encoding : utf-8 -*-
class AttachmentFile < Asset

  sunrise_uploader AttachmentFileUploader

  validates_filesize_of :data, :maximum => 150.megabytes

end

# == Schema Information
#
# Table name: assets
#
#  id                :integer(4)      not null, primary key
#  data_file_name    :string(255)     not null
#  data_content_type :string(255)
#  data_file_size    :integer(4)
#  assetable_id      :integer(4)      not null
#  assetable_type    :string(25)      not null
#  type              :string(25)
#  guid              :string(10)
#  locale            :integer(1)      default(0)
#  user_id           :integer(4)
#  sort_order        :integer(4)      default(0)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  is_main           :boolean(1)      default(FALSE), not null
#

