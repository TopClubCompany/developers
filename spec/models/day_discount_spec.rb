require 'spec_helper'

describe DayDiscount do
  pending "add some examples to (or delete) #{__FILE__}"
end
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

