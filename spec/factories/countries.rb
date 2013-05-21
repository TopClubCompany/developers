# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  slug       :string(255)
#  is_visible :boolean          default(TRUE)
#  position   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_countries_on_slug  (slug) UNIQUE
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :country do
  end
end
