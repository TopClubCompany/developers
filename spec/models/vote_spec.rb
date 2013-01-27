require 'spec_helper'

describe Vote do
  pending "add some examples to (or delete) #{__FILE__}"
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

