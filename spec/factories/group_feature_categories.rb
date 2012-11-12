# == Schema Information
#
# Table name: group_feature_categories
#
#  id               :integer          not null, primary key
#  group_feature_id :integer
#  category_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_group_feature_categories_on_category_id       (category_id)
#  index_group_feature_categories_on_group_feature_id  (group_feature_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_feature_category do
  end
end
