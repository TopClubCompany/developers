# == Schema Information
#
# Table name: day_discounts
#
#  id                       :integer          not null, primary key
#  day_discount_schedule_id :integer
#  from_time                :time
#  to_time                  :time
#  discount                 :float
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :day_discount do
  end
end
