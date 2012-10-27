require 'spec_helper'

describe PlaceCategory do
  pending "add some examples to (or delete) #{__FILE__}"
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

