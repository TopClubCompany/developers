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
    name { generate(:random_string) }
    ignore do
      feature_items 2
    end

    after(:create) do |group_feature, evaluator|
      FactoryGirl.create_list(:feature_item, evaluator.feature_items, name: generate(:random_string), group_feature: group_feature)
    end
  end
end
