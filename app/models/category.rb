# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  icon        :string(255)
#

class Category < ActiveRecord::Base
  has_many :places

  attr_accessible :is_visible, :parent_id, :name, :description

  belongs_to :user

  has_many :pictures, :as => :assetable, :dependent => :destroy
  has_one :category_image, :as => :assetable, :dependent => :destroy

  fileuploads :pictures, :category_image
  translates :name, :description

  include Utils::Models::Headerable
  include Utils::Models::NestedSet
  include TheSortableTree::Scopes
  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds


  default_scope reversed_nested_set.includes(:translations)

end
