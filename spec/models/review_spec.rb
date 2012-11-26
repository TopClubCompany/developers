require 'spec_helper'

describe Review do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: reviews
#
#  id              :integer          not null, primary key
#  reviewable_id   :integer
#  reviewable_type :string(255)
#  title           :string(255)
#  content         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

