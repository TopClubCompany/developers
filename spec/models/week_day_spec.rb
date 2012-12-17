require 'spec_helper'

describe WeekDay do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: week_days
#
#  id             :integer          not null, primary key
#  start_at       :float
#  end_at         :float
#  start_break_at :float
#  end_break_at   :float
#  place_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_week_days_on_place_id  (place_id)
#

