FactoryGirl.define do
  sequence(:random_string) {|n| Faker::Lorem.sentence }
end