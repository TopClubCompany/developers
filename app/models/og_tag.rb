class OgTag < ActiveRecord::Base

  attr_accessible :og_type, :header_id

  belongs_to :header

  translates :title, :description, :url, :image, :site_name

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

end
# == Schema Information
#
# Table name: og_tags
#
#  id         :integer          not null, primary key
#  og_type    :string(255)
#  header_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_og_tags_on_header_id  (header_id)
#

