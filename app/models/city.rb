class City < ActiveRecord::Base

  attr_accessible :is_visible, :position, :name, :description, :plural_name

  has_many :users

  translates :name, :description, :plural_name

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds
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
#
# Indexes
#
#  index_cities_on_slug  (slug) UNIQUE
#

