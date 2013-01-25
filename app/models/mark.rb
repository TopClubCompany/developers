class Mark < ActiveRecord::Base
  attr_accessible :value, :mark_type_id
  belongs_to :review
  belongs_to :mark_type

  validates_inclusion_of :value, in: 1..5, :message => "can only be between 1 and 5."

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

