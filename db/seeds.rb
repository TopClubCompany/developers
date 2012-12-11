#encoding: utf-8

def insert_default_user(email, admin = true)
  password            = Rails.env.production? ? Devise.friendly_token.first(6) : (1..6).to_a.join
  user                = User.new(email: email, password: password, password_confirmation: password).generate_default_fields
  user.login          = admin ? 'admin' : 'user'
  (user.user_role_id  = UserRoleType.admin.id) if admin
  user.activate.skip_confirmation!
  user.save!
  puts "#{admin ? 'Admin: ' : 'User: '}#{email}, #{password}"
end

def add_categories
  Category.full_truncate
  main_rest = Category.create(name: "Рестораны", description: "Рестораны", user_id: User.first.id)
  %w(кафе пиццерии бары пабы кофейни суши загородные).each do |category|
    Category.create(name: category, description: category, user_id: User.first.id, parent_id: main_rest.id)
  end

  night = Category.create(name: "Ночная жизнь", description: "Ночная жизнь", user_id: User.first.id)

  %w(ночные\ клубы караоке).each do |category|
    Category.create(name: category, description: category, user_id: User.first.id, parent_id: night.id)
  end
  puts 'categories added successfully'
end

def add_kitchens
  Kitchen.full_truncate
  kitchens = %w(Английская Австрийская Бельгийская Болгарская Валлийская Венгерская Голландская Греческая
                Датская Итальянская Испанская Ирландская Немецкая Луизианская Польская Португальская
                Румынская Финская Французская Чешская Швейцарская Шведская Шотландская Югославская Норвежская
                Вьетнамская Индийская Китайская Корейская Малайзийская Монгольская Тайская Турецкая Японская)
  kitchens.each do |kitchen_name|
    Kitchen.create(name: kitchen_name, description: Faker::Lorem.sentence, user_id: User.first.id)
  end
  puts 'kitchens added successfully'
end

def add_test_stuff
  Place.full_truncate
  15.times do
    kitchen   = Kitchen.all.sample(2)
    category  = Category.all.sample(2)
    place = Place.create(name: Faker::Company.name, description: Faker::Lorem.sentence, user_id: User.first.id,
                           phone: Faker::PhoneNumber.phone_number, url: Faker::Internet.http_url, avg_bill: BillType.all.sample.id)


      latitude = [50.4481, 50.4454, 50.4467, 50.4439].sample
      longitude =  [30.5002, 30.5440, 30.5451, 30.5455, 30.5459].sample
      location = Location.new({latitude: latitude, longitude: longitude})
      place.location   = location
      place.categories << category
      place.kitchens   << kitchen
      2.times do
        review = FactoryGirl.build(:review, user_id: User.last.id)
        MarkType.all.each { |mark_type| review.marks << FactoryGirl.build(:mark, mark_type_id: mark_type.id) }
        place.reviews << review
        place.notes   << FactoryGirl.build(:note)
        place.events  << FactoryGirl.build(:event)
      end
      puts "place created!"
    end
  puts 'test stuff added successfully'
end

def insert_group_feature
  GroupFeature.all.map(&:destroy)
  groups_features = [{name: "Wi-Fi", features: %w(Free Paid)},
                     {name: "Parking", features: %w(Street Garage Valet Private\ Lot Validated)},
                     {name: "Meals Served", features: %w(Breakfast Brunch Lunch Dinner Dessert Late\ Night)},
                     {name: "Alcohol", features: %w(Full\ Bar Beer\ &\ Wine\ Only Happy\ Hour)},
                     {name: "General features", features: %w(Offering\ a\ Deal Open\ Now\ (11:18\ am) Good\ for\ Kids
                                                Take-out Open\ Now\ (11:18\ am) Takes\ Reservations Accepts\ Credit\ Cards
                                                Delivery Outdoor\ Seating Good\ for\ Groups Waiter\ Service Wheelchair\ Accessible Has\ TV)},
                     {name: "Ambience", features: %w(Authentic\ Favorites Cozy\ &\ Casual Dating\ Destination)}
                    ]

  groups_features.each do |group_feature|
    g = GroupFeature.create({name_ru: group_feature[:name]})
    g.category_ids = [Category.all.sample.id]
    g.save!
    group_feature[:features].each do |item|
      FeatureItem.create({name_ru: item, group_feature_id: g.id})
    end
  end
  puts 'group features added successfully'
end


def insert_mark_types
  %w(pricing service food ambiance).each do |type|
    MarkType.create(name: type, description: Faker::Lorem.sentence(10))
  end
  puts 'mark types added successfully'
end

def insert_city
  City.full_truncate
  [{name: "Kiev", slug: "kiev"},{name: "Kharkiv", slug: "kharkiv"}, {name: "Odessa", slug: "odessa"},
  {name: "Dnepropetrivsk", slug: "dnepropetrivsk"}, {name: "Donetsk", slug: "donetsk"}, {name: "Lviv", slug: "lviv"}
  ].each do |city|
    City.create do |c|
      c.name = city[:name]
      c.slug = city[:slug]
    end.save!
  end
  puts 'cities added successfully'
end

def insert_default_place_pictures
  pictures_path = Rails.root.join('public', 'images', 'default_place_pictures', '*.{jpg, png, jpeg}')
  pictures = Dir.glob(pictures_path).map { |entry| File.new(entry)}
  Place.all.each { |place| place.place_image = PlaceImage.new(data: pictures.sample, is_main: true) }
  puts 'place images added successfully'
end

#User.full_truncate
#insert_default_user('admin@adm.com')
#insert_default_user('user@usr.com', false)
add_categories
add_kitchens
insert_mark_types
add_test_stuff
insert_default_place_pictures
insert_group_feature
insert_city

