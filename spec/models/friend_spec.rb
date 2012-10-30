require 'spec_helper'

describe Friend do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: friends
#
#  id         :integer          not null, primary key
#  social_id  :string(255)      not null
#  name       :string(255)
#  type       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_friends_on_social_id  (social_id)
#  index_friends_on_user_id    (user_id)
#

