# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  place_id   :integer
#  body       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reviews_on_user_id  (user_id)
#

class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :place



end


