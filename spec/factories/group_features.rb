# == Schema Information
#
# Table name: group_features
#
#  id         :integer          not null, primary key
#  is_visible :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_feature do
  end
end
