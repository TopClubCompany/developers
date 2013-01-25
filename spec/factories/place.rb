FactoryGirl.define do
  factory :place do
    name        { Faker::Company.name }
    description { Faker::Lorem.paragraphs(5).join('') }
    phone       { Faker::PhoneNumber.phone_number }
    url         { Faker::Internet.http_url }
    avg_bill    { BillType.all.sample.id }
  end
end