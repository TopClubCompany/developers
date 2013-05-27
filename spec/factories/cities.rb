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
#  phone_code :string(255)
#
# Indexes
#
#  index_cities_on_country_id  (country_id)
#  index_cities_on_slug        (slug) UNIQUE
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :city do
  end
end
