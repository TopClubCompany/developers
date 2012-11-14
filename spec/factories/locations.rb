# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  locationable_id   :integer          not null
#  locationable_type :string(50)       not null
#  street            :string(255)
#  city              :string(255)
#  state             :string(255)
#  zip               :string(255)
#  latitude          :float
#  longitude         :float
#  country           :string(255)
#  distance          :float
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
    locationable_type "Place"
    locationable_id 1
    latitude 50.4419
    longitude 30.4977
  end
end
