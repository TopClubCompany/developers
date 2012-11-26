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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mark do
    food 1
    service 1
    pricing 1
    ambiance 1
    references ""
  end
end
