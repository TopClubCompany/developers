class PlaceKitchen < ActiveRecord::Base
  attr_accessible :place_id, :kitchen_id

  belongs_to :place
  belongs_to :kitchen

end