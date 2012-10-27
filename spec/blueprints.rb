#coding: utf-8

require 'machinist/active_record'

Category.blueprint {
  name        { ['Рестораны', 'Проведение событий', 'Автомобили', 'Доставка еды', 'Ночная жизнь', 'Краcота и здоровье', 'Здоровье и медицина', 'Азартные игры', 'Еда', 'Искусство', 'Домашние животные', 'Родители и дети', 'Покупки', 'Спортивные события', 'Недвижимость', 'Образование', 'Гостиницы и туризм', 'Локальные сервисы', 'Финансы'].sample }
  description { Faker::Lorem.sentence }
}


Place.blueprint {
  name        { Faker::Company.name }
  description { Faker::Lorem.sentence }
  picture     { "http://lorempixel.com/98/73/food" }
  address     { Faker::Address.street_address }
  lat         { Faker::Geolocation.lat }
  lng         { Faker::Geolocation.lng }
  avgbill     { rand 4 }
  phone       { Faker::PhoneNumber.phone_number }
  url         { Faker::Internet.http_url }
}

Kitchen.blueprint {
  name        { %w(Английская Австрийская Бельгийская Болгарская Валлийская Венгерская Голландская Греческая Датская Итальянская Испанская Ирландская Немецкая Луизианская Польская Португальская Румынская Финская Французская Чешская Швейцарская Шведская Шотландская Югославская Норвежская Вьетнамская Индийская Китайская Корейская Малайзийская Монгольская Тайская Турецкая Японская).sample }
  description { Faker::Lorem.sentence }
}

User.blueprint {
  firts_name                  { 'Other user' }
  email                 { 'hello@example.com' }
  photo                 { 'http://lorempixel.com/50/50/people/' }
  password              { 'password' }
  password_confirmation { 'password' }
}

Note.blueprint {
  picture     { 'http://www.dummyimage.com/101x72/0a0dcc/fff.png&text=PlaceNoteImage' }
  title       { Faker::Lorem.sentence  }
  body        { Faker::Lorem.paragraph }
}

Selection.blueprint {
  picture     { 'http://lorempixel.com/43/30/' }
  kind        { %w(Город События Улица Двор ЧтоЭто).sample }
  description { Faker::Lorem.sentence }
}

Review.blueprint {
  body { Faker::Lorem.sentence }
}

Event.blueprint {
  start_at { (-rand(30.days)).ago }
  picture  { "http://lorempixel.com/60/60/" }
  kind     { %w(Концерт Спектакль Выставка Встреча Вечеринка Выступление Презентация Пресс-конференция Лекция Cеминар Конкурс).sample }
  title    { Faker::Lorem.sentence }
}
