FactoryGirl.define do
  sequence(:random_string) {|n| Forgery(:lorem_ipsum).words(10) }
end