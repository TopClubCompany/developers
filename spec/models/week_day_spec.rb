require 'spec_helper'

describe WeekDay do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: week_days
#
#  id             :integer          not null, primary key
#  start_at       :time
#  end_at         :time
#  start_break_at :time
#  end_break_at   :time
#  day_type_id    :integer          not null
#  is_working     :boolean          default(FALSE)
#  place_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_week_days_on_day_type_id  (day_type_id)
#  index_week_days_on_place_id     (place_id)
#

