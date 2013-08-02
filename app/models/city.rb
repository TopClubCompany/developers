class City < ActiveRecord::Base

  attr_accessible :is_visible, :position, :name, :letter, :description, :plural_name, :country_id, :latitude, :longitude,
                  :phone_code, :support_phone

  has_many :users

  belongs_to :country

  translates :name, :description, :plural_name, :letter

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  include Utils::Models::Headerable


  ac_field

  def self.for_reg(current_city_id)
    cities = City.where("slug != ?",current_city_id)
    cities.unshift(find(current_city_id))
  end
end
# == Schema Information
#
# Table name: cities
#
#  id            :integer          not null, primary key
#  slug          :string(255)      not null
#  is_visible    :boolean          default(TRUE)
#  position      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  country_id    :integer
#  latitude      :float
#  longitude     :float
#  phone_code    :string(255)
#  support_phone :string(255)
#
# Indexes
#
#  index_cities_on_country_id  (country_id)
#  index_cities_on_slug        (slug) UNIQUE
#

