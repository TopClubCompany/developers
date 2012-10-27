class PlaceCategory < ActiveRecord::Base

  attr_accessible :place_id, :category_id

  belongs_to :category
  belongs_to :place

end
