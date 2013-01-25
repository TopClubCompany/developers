require 'spec_helper'

describe PlaceMenuItem do
  pending "add some examples to (or delete) #{__FILE__}"
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

