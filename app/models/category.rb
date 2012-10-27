class Category < ActiveRecord::Base

  has_many :place_categories, :dependent => :destroy
  has_many :places, :through => :place_categories

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

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  slug       :string(255)      not null
#  user_id    :integer
#  is_visible :boolean          default(TRUE), not null
#  parent_id  :integer
#  lft        :integer          default(0)
#  rgt        :integer          default(0)
#  depth      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_lft_and_rgt  (lft,rgt)
#  index_categories_on_parent_id    (parent_id)
#  index_categories_on_slug         (slug) UNIQUE
#  index_categories_on_user_id      (user_id)
#

