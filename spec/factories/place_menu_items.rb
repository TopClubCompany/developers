# == Schema Information
#
# Table name: place_menu_items
#
#  id            :integer          not null, primary key
#  price         :float            default(0.0)
#  place_menu_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_place_menu_items_on_place_menu_id  (place_menu_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place_menu_item do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentences(3).join(' ') }
    price { rand(1...100) }
  end
end
