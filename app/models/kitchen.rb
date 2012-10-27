# == Schema Information
#
# Table name: kitchens
#
#  id         :integer          not null, primary key
#  slug       :string(255)      not null
#  user_id    :integer
#  is_visible :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_kitchens_on_slug     (slug) UNIQUE
#  index_kitchens_on_user_id  (user_id)
#

class Kitchen < ActiveRecord::Base
  #has_many :places

  attr_accessible :is_visible, :name, :description

  belongs_to :user

  has_many :pictures, :as => :assetable, :dependent => :destroy
  #has_one :image, :as => :assetable, :dependent => :destroy

  fileuploads :pictures

  translates :name, :description

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

end
