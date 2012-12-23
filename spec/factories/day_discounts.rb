# == Schema Information
#
# Table name: day_discounts
#
#  id          :integer          not null, primary key
#  week_day_id :integer
#  from_time   :time
#  to_time     :time
#  discount    :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_day_discounts_on_week_day_id  (week_day_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :day_discount do
  end
end
