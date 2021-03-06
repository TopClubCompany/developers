class UserFavoritePlace < ActiveRecord::Base
  attr_accessible :user_id, :place_id

  belongs_to :user
  belongs_to :place

  def self.liked?(user_id, place_id)
    if user_id && place_id
      where("user_id = ? AND place_id = ?", user_id, place_id).size > 0
    else
      false
    end
  end

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

