class City < ActiveRecord::Base

  attr_accessible :is_visible, :position, :name, :description, :plural_name, :country_id, :latitude, :longitude

  has_many :users

  belongs_to :country

  translates :name, :description, :plural_name

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds


  ac_field
end
# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  slug       :string(255)      not null
#  is_visible :boolean          default(TRUE)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :integer
#  latitude   :float
#  longitude  :float
#
# Indexes
#
#  index_cities_on_country_id  (country_id)
#  index_cities_on_slug        (slug) UNIQUE
#

