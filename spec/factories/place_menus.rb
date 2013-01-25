# == Schema Information
#
# Table name: place_menus
#
#  id         :integer          not null, primary key
#  place_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_place_menus_on_place_id  (place_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place_menu do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentences(3).join(' ') }
  end
end
