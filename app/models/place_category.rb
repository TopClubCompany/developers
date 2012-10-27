class PlaceCategory < ActiveRecord::Base

  attr_accessible :place_id, :category_id

  belongs_to :category
  belongs_to :place

end
# == Schema Information
#
# Table name: place_categories
#
#  id          :integer          not null, primary key
#  category_id :integer
#  place_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_place_categories_on_category_id  (category_id)
#  index_place_categories_on_place_id     (place_id)
#

