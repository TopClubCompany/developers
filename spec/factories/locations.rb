# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  locationable_id   :integer          not null
#  locationable_type :string(50)       not null
#  zip               :string(255)
#  latitude          :float
#  longitude         :float
#  distance          :float
#  house_number      :string(255)
#  country_code      :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_locations_on_locationable_id_and_locationable_type  (locationable_id,locationable_type)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    latitude  { [50.4481, 50.1454, 50.3467, 51.4439].sample }
    longitude { [30.1002, 30.2440, 30.3451, 30.4455, 30.9459].sample }
  end
end
