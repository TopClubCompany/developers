#encoding: utf-8
FactoryGirl.define do
  factory :selection do
    picture     'http://lorempixel.com/43/30/'
    kind        %w(Город События Улица Двор ЧтоЭто).sample
    description Faker::Lorem.sentence
  end
end