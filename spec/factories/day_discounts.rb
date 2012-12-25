# == Schema Information
#
# Table name: day_discounts
#
#  id          :integer          not null, primary key
#  week_day_id :integer
#  from_time   :decimal(4, 2)
#  to_time     :decimal(4, 2)
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
    discount    { (5...70).step(5).sample }
    title       { "Special offer!!! " + %w|Day\ of\ heroes! Big\ boom\ day! Anniversary! Jubilee! Opening!|.sample }
    description { "#{discount.to_i}% off your food bill" }
  end
end
