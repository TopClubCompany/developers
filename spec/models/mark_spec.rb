require 'spec_helper'

describe Mark do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: marks
#
#  id         :integer          not null, primary key
#  food       :integer
#  service    :integer
#  pricing    :integer
#  ambiance   :integer
#  review_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_marks_on_ambiance   (ambiance)
#  index_marks_on_food       (food)
#  index_marks_on_pricing    (pricing)
#  index_marks_on_review_id  (review_id)
#  index_marks_on_service    (service)
#

