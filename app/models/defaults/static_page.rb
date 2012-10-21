# -*- encoding : utf-8 -*-
class StaticPage < ActiveRecord::Base
  include Utils::Models::StaticPage

  attr_accessible :structure_id, :title, :content, :kind, :is_visible

  has_many :pictures, :as => :assetable, :dependent => :destroy
  has_one :photo, :as => :assetable, :dependent => :destroy
  has_many :attachment_files, :as => :assetable, :dependent => :destroy, :autosave => true

  enumerated_attribute :static_page_type, :id_attribute => :kind

  fileuploads :pictures, :photo, :attachment_files
  translates :title, :content
  include Utils::Models::Base
  include Utils::Models::Translations

  ac_field :title

end

# == Schema Information
#
# Table name: static_pages
#
#  id           :integer(4)      not null, primary key
#  structure_id :integer(4)      not null
#  user_id      :integer(4)
#  is_visible   :boolean(1)      default(TRUE), not null
#  delta        :boolean(1)      default(TRUE), not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  import_id    :integer(4)
#

