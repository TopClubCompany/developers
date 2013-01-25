class Vote < ActiveRecord::Base
  attr_accessible :user_id, :review_id, :vote_type_id

  belongs_to :vote_type
  belongs_to :review
  belongs_to :user

  scope :helpful, where(vote_type_id: VoteType.find_by_title('helpful').try(:id))
  scope :unhelpful, where(vote_type_id: VoteType.find_by_title('unhelpful').try(:id))

end
# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  review_id    :integer
#  vote_type_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_votes_on_review_id     (review_id)
#  index_votes_on_user_id       (user_id)
#  index_votes_on_vote_type_id  (vote_type_id)
#

