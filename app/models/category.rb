class Category < ActiveRecord::Base

  has_many :place_categories, :dependent => :destroy
  has_many :places, :through => :place_categories

  attr_accessible :is_visible, :parent_id, :name, :description, :user_id

  belongs_to :user

  has_many :pictures, :as => :assetable, :dependent => :destroy
  has_one :category_image, :as => :assetable, :dependent => :destroy

  has_many :group_feature_categories, :dependent => :destroy
  has_many :group_features, :through => :group_feature_categories

  fileuploads :pictures, :category_image
  translates :name, :description

  include Utils::Models::Headerable
  include Utils::Models::NestedSet
  include TheSortableTree::Scopes
  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  scope :children, -> { where("parent_id IS NOT NULL") }


  default_scope reversed_nested_set.includes(:translations)

  ac_field

  self.per_page = 1000


  def self.paginate(options = {})
    includes(:parent).paginate(:page => options[:page], :per_page => options[:per_page]).to_a
  end

  def root_id
    root.try(:id)
  end

  def to_indexed_json
    attrs = [:id, :slug, :created_at, :parent_id, :root_id, :lft, :for_input_token, :depth]
    Jbuilder.encode do |json|
      json.(self, *attrs)
      json.(self, *self.class.ac_search_attrs)
      json.parent_name parent.try(:name)
    end
  end

  def self.for_input_token(r, attr='name')
    r.for_input_token
  end

  def for_input_token
    input_name = self_and_ancestors.map{|r| r.try(:name)}
    input_name[-1] = "<b>#{input_name.last}</b>"
    {:name => input_name.join(' - '), :id => self.id}
  end


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

