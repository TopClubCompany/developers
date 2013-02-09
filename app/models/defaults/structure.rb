# -*- encoding : utf-8 -*-
class Structure < ActiveRecord::Base
  include Utils::Models::Structure
  include TheSortableTree::Scopes
  
  attr_accessible :kind, :position, :parent_id, :title, :is_visible, :structure_type, :position_type

  has_many :pictures, :as => :assetable, :dependent => :destroy

  has_many :visible_children, :class_name => name, :foreign_key => 'parent_id', :conditions => {:is_visible => true}

  fileuploads :pictures
  translates :title

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  default_scope reversed_nested_set.includes(:translations)

  alias_attribute :name, :title

  ac_field :title

  self.per_page = 1000


  def to_indexed_json
    attrs = [:id, :slug, :created_at, :parent_id, :lft, :kind]
    Jbuilder.encode do |json|
      json.(self, *attrs)
      json.(self, *self.class.ac_search_attrs)
    end
  end


  def should_generate_new_friendly_id?
    slug.blank? && new_record?
  end
end
# == Schema Information
#
# Table name: structures
#
#  id         :integer          not null, primary key
#  slug       :string(50)       not null
#  kind       :integer          default(1)
#  position   :integer          default(1)
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
#  index_structures_on_kind_and_slug  (kind,slug) UNIQUE
#  index_structures_on_lft_and_rgt    (lft,rgt)
#  index_structures_on_parent_id      (parent_id)
#  index_structures_on_user_id        (user_id)
#

