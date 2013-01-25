class PlaceMenuItem < ActiveRecord::Base
  attr_accessible :title, :description, :place_menu_id, :price

  belongs_to :place_menu

  translates :title, :description

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds
end
# == Schema Information
#
# Table name: place_menu_items
#
#  id            :integer          not null, primary key
#  price         :float            default(0.0)
#  place_menu_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_place_menu_items_on_place_menu_id  (place_menu_id)
#

