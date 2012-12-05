#encoding: utf-8
FactoryGirl.define do
  factory :event do
      start_at { rand(30.days).ago }
      picture  "http://lorempixel.com/60/60/"
      kind     %w(Концерт Спектакль Выставка Встреча Вечеринка Выступление
                  Презентация Пресс-конференция Лекция Cеминар Конкурс).sample
      title    Faker::Lorem.sentence
  end
end