FactoryGirl.define do
  factory :category do
    name { generate(:random_string) }
    ignore do
      group_features 2
    end

    after(:create) do |category, evaluator|
      FactoryGirl.create_list(:group_feature, evaluator.group_features, name: generate(:random_string), categories: [category])
    end

  end
end
