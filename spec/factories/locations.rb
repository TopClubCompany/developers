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
    latitude  { [50.4481, 50.4454, 50.4467, 50.4439].sample }
    longitude { [30.5002, 30.5440, 30.5451, 30.5455, 30.5459].sample }
  end
end
