class Location < ActiveRecord::Base
  attr_accessible :locationable_id, :locationable_type, :street, :city, :zip, :latitude, :longitude, :country

  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  belongs_to :locationable, :polymorphic => true

  before_save :prepere_location

  def prepere_location
    geo_res = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{latitude}, #{longitude}"
    self.street = geo_res.street_address
    self.city = geo_res.city
    self.zip = geo_res.zip
    self.country = geo_res.country
  end

end
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
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_locations_on_locationable_id_and_locationable_type  (locationable_id,locationable_type)
#

