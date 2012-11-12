class PlaceFeatureItem < ActiveRecord::Base
  belongs_to :place
  belongs_to :feature_item
end
# == Schema Information
#
# Table name: place_feature_items
#
#  id              :integer          not null, primary key
#  place_id        :integer
#  feature_item_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_place_feature_items_on_feature_item_id  (feature_item_id)
#  index_place_feature_items_on_place_id         (place_id)
#

