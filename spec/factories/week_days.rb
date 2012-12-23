# == Schema Information
#
# Table name: week_days
#
#  id          :integer          not null, primary key
#  start_at    :decimal(4, 2)
#  end_at      :decimal(4, 2)
#  day_type_id :integer          not null
#  is_working  :boolean          default(FALSE)
#  place_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_week_days_on_day_type_id  (day_type_id)
#  index_week_days_on_place_id     (place_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :week_day do
    start_at       { "#{rand(7..11)}.#{(10..60).step(5).sample}".to_f }
    end_at         { "#{rand(15..24)}.#{(10..60).step(5).sample}".to_f }
  end
end
