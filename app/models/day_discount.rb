class DayDiscount < ActiveRecord::Base
  attr_accessible :day_discount_schedule_id, :from_time, :to_time, :discount
end
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

