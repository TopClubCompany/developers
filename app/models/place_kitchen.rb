# == Schema Information
#
# Table name: place_kitchens
#
#  id         :integer          not null, primary key
#  place_id   :integer
#  kitchen_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_place_kitchens_on_kitchen_id  (kitchen_id)
#  index_place_kitchens_on_place_id    (place_id)
#

class PlaceKitchen < ActiveRecord::Base
  attr_accessible :place_id, :kitchen_id

  belongs_to :place
  belongs_to :kitchen

end
