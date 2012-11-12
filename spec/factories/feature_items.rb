# == Schema Information
#
# Table name: feature_items
#
#  id               :integer          not null, primary key
#  is_visible       :boolean          default(TRUE)
#  group_feature_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_feature_items_on_group_feature_id  (group_feature_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feature_item do
  end
end
