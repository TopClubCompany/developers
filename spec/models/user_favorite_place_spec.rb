require 'spec_helper'

describe UserFavoritePlace do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: user_favorite_places
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  place_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_favorite_places_on_place_id  (place_id)
#  index_user_favorite_places_on_user_id   (user_id)
#

