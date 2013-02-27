# == Schema Information
#
# Table name: letters
#
#  id         :integer          not null, primary key
#  kind       :integer          not null
#  is_visible :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :letter do
  end
end
