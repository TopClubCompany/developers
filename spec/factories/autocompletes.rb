# == Schema Information
#
# Table name: autocompletes
#
#  id         :integer          not null, primary key
#  term       :string(255)
#  freq       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :autocomplete do
  end
end
