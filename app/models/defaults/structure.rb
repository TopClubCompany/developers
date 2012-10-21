# -*- encoding : utf-8 -*-
class Structure < ActiveRecord::Base
  include Utils::Models::Structure
  include TheSortableTree::Scopes
  
  attr_accessible :kind, :position, :parent_id, :title, :redirect_url, :is_visible, :structure_type, :position_type,
                  :linked_id, :linked_type, :is_hidden, :slug

  has_one :menu_image, :as => :assetable, :dependent => :destroy
  has_many :pictures, :as => :assetable, :dependent => :destroy

  belongs_to :linked, :polymorphic => true

  has_many :visible_children, :class_name => name, :foreign_key => 'parent_id', :conditions => {:is_visible => true}

  fileuploads :menu_image, :pictures
  translates :title, :redirect_url
  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  default_scope reversed_nested_set.includes(:translations)

  alias_attribute :name, :title

  ac_field :title

  self.per_page = 1000

  def linked?
    linked_id.present? && linked
  end

  def linked_condition
    linked_key ? {linked_key => linked_id.to_s} : {}
  end

  def linked_key
    @linked_key ||= case linked
      when Catalogue
        'catalogue_ids'
      when Section
        'section_ids'
      when PGroup
        'p_group_ids'
      when Company
        'company_id'
      when Style
        'style_id'
      else
        nil
    end
  end

  def to_indexed_json
    attrs = [:id, :slug, :created_at, :parent_id, :lft, :kind]
    Jbuilder.encode do |json|
      json.(self, *attrs)
      json.(self, *self.class.ac_search_attrs)
    end
  end

  def linked_pre
    linked ? [linked.for_input_token] : []
  end

  def self.linked_types
    [Catalogue, Section, PGroup, Company, Style]
  end

  def should_generate_new_friendly_id?
    slug.blank? && new_record?
  end
end

# == Schema Information
#
# Table name: structures
#
#  id          :integer(4)      not null, primary key
#  slug        :string(50)      not null
#  kind        :integer(1)      default(1)
#  position    :integer(2)      default(1)
#  user_id     :integer(4)
#  is_visible  :boolean(1)      default(TRUE), not null
#  delta       :boolean(1)      default(TRUE), not null
#  parent_id   :integer(4)
#  lft         :integer(4)      default(0)
#  rgt         :integer(4)      default(0)
#  depth       :integer(4)      default(0)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  import_id   :integer(4)
#  linked_id   :integer(4)
#  linked_type :string(50)
#  is_hidden   :boolean(1)      default(FALSE), not null
#

