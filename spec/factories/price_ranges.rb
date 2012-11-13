# == Schema Information
#
# Table name: price_ranges
#
#  id         :integer          not null, primary key
#  min_price  :float
#  max_price  :float
#  avg_price  :float
#  place_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price_range do
    name ""
  end
end
