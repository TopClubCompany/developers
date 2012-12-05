FactoryGirl.define do
  factory :note do
      picture 'http://www.dummyimage.com/101x72/0a0dcc/fff.png&text=PlaceNoteImage'
      title   Faker::Lorem.sentence
      body    Faker::Lorem.paragraph
  end
end