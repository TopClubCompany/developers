require 'spec_helper'

describe Mark do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: marks
#
#  id           :integer          not null, primary key
#  value        :integer
#  mark_type_id :integer
#  review_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_marks_on_mark_type_id  (mark_type_id)
#  index_marks_on_review_id     (review_id)
#

