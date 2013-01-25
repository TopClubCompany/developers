class PlaceMenu < ActiveRecord::Base
  attr_accessible :title, :description, :place_id, :place_menu_items_attributes

  belongs_to :place
  has_many :place_menu_items, :dependent => :destroy

  accepts_nested_attributes_for :place_menu_items,
                                :allow_destroy => true, :reject_if => :all_blank

  translates :title, :description

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds
end
# == Schema Information
#
# Table name: place_menus
#
#  id         :integer          not null, primary key
#  place_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_place_menus_on_place_id  (place_id)
#

