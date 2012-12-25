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


  def address
    street
  end

  private

  def prepare_location
    if self.latitude_changed? || self.longitude_changed?
      languages = I18n.available_locales.map(&:to_s)
      geo_res = Utils::Maps::OpenStreetMap.reverse_geocode({:lat => latitude, :lon => longitude, :"accept-language" => languages})

      languages.each do |language|
        self.send("city_#{language}=", geo_res.send(language).address.try(:state))
        self.send("street_#{language}=", geo_res.send(language).address.try(:road))
        self.send("country_#{language}=", geo_res.send(language).address.try(:country))
        self.send("county_#{language}=", geo_res.send(language).address.try { |address| address.county.split(' ').first if  address.county})
      end

      self.zip = geo_res.send(languages[0]).address.try(:postcode)
      self.house_number = geo_res.send(languages[0]).address.try(:house_number)
      self.country_code = geo_res.send(languages[0]).address.try(:country_code)
    end
  end



end
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

