# == Schema Information
#
# Table name: kitchens
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Kitchen < ActiveRecord::Base
  #has_many :places

  attr_accessible :is_visible, :name, :description

  belongs_to :user

  has_many :pictures, :as => :assetable, :dependent => :destroy
  has_one :image, :as => :assetable, :dependent => :destroy

  fileuploads :pictures, :image

  translates :name, :description

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

end
