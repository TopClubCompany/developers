class Location < ActiveRecord::Base
  attr_accessible :locationable_id, :locationable_type, :zip, :latitude, :longitude, :house_number, :country_code,
                  :street, :city, :county, :country

  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude


  belongs_to :locationable, :polymorphic => true

  before_save :prepare_location

  translates :street, :city, :country, :county

  include Utils::Models::Base
  include Utils::Models::Translations

  alias_method :name_countries, :country

  def prepare_location
    if self.latitude_changed? || self.longitude_changed?
      #begin
      languages = I18n.available_locales.map(&:to_s)
      geo_res = Utils::Maps::OpenStreetMap.reverse_geocode({:lat => latitude, :lon => longitude, :"accept-language" => languages})

      languages.each do |language|
        self.send("street_#{language}=", geo_res.send(language).address.try(:road))
        self.send("city_#{language}=", geo_res.send(language).address.try(:state))
        self.send("country_#{language}=", geo_res.send(language).address.try(:country))
        self.send("county_#{language}=", geo_res.send(language).address.try(:county))
      end

      zip = geo_res.send(languages[0]).address.try(:postcode)
      house_number = geo_res.send(languages[0]).address.try(:house_number)
      country_code = geo_res.send(languages[0]).address.try(:country_code)

      #rescue => e

      #end
    end
  end

  def address
    street
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
#  distance          :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_locations_on_locationable_id_and_locationable_type  (locationable_id,locationable_type)
#

