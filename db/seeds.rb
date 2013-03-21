#encoding: utf-8
require_relative "letter_seed"

def insert_fake_user(email, name, role = :default)
  user = FactoryGirl.build(:user, role.to_sym, email: email, phone: "+38(044)111-11-11", name: name)
  user.activate.skip_confirmation!
  user.save!
  p '=============== User ================='
  p "email: #{user.email} password: #{user.password} role: #{user.role_title}"
end

def insert_fake_users(number = 100)

  first_names_men = File.open('db/first_names_men.txt', 'r').map do |line|
    line.strip
  end

  second_names_men = File.open('db/second_names_men.txt', 'r').map do |line|
    line.strip
  end

  first_names_women = File.open('db/first_names_women.txt', 'r').map do |line|
    line.strip
  end

  second_names_women = File.open('db/second_names_women.txt', 'r').map do |line|
    line.strip
  end
  
  loop do
    if number == 0
      break
    end

    name = number % 2 == 0 ? first_names_men.sample + " " + second_names_men.sample : first_names_women.sample + " " + second_names_women.sample

    puts "User " + name + " added!"

    number = number - 1
  end
end

def insert_default_user(email, role = :default)
  user = FactoryGirl.build(:user, role.to_sym, email: email, phone: "+38(044)111-11-11")
  user.activate.skip_confirmation!
  user.save!
  p '=============== User ================='
  p "email: #{user.email} password: #{user.password} role: #{user.role_title}"
end

def add_categories
  Category.full_truncate
  main_rest = Category.create(name: "Рестораны", description: "Рестораны", user_id: User.first.id)
  %w(Coffee Bars\ &\ pubs Pizza Sushi Café Restaurants).each_with_index do |category, index|
    params = case index
               when 0
                {css_id: "coffee", is_visible_on_main: true, position: 0}
               when 1
                 {css_id: "bars_and_pubs", is_visible_on_main: true, position: 1}
                when 2
                  {css_id: "pizza", is_visible_on_main: true, position: 2}
               when 3
                 {css_id: "sushi", is_visible_on_main: true, position: 3}
               when 4
                 {css_id: "cafe", is_visible_on_main: true, position: 4}
               when 5
                 {css_id: "restaurants", is_visible_on_main: true, position: 5}
               else
                {}
              end

    cat_params = {name: category, plural_name: category, description: category, user_id: User.first.id, parent_id: main_rest.id}.merge!(params)
    Category.create(cat_params)
  end

  night = Category.create(name: "Ночная жизнь", description: "Ночная жизнь", user_id: User.first.id)

  %w(Night clubs Karaoke).each_with_index do |category, index|
    params = case index
               when 0
                 {css_id: "night_clubs", is_visible_on_main: true, position: 6}
               when 1
                 {css_id: "karaoke", is_visible_on_main: true, position: 7}
               else
                {}
             end
    cat_params = {name: category, description: category, user_id: User.first.id, parent_id: night.id}.merge!(params)
    Category.create(cat_params)
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
  WeekDay.full_truncate
  35.times do
    kitchen  = Kitchen.all.sample(2)
    category = Category.all.sample(2)
    location = FactoryGirl.build(:location)

    place = FactoryGirl.create(:place, user_id: User.first.id)

    week_days = DayType.all.map { |day| FactoryGirl.build(:week_day, day_type_id: day.id, is_working: true)}
    week_days.each do |week_day|
      week_day.day_discounts <<
        FactoryGirl.build(:day_discount, from_time: (week_day.start_at + rand(4)),
                          to_time: (week_day.start_at + rand(5..8)), is_discount: false)

        week_day.day_discounts <<
          FactoryGirl.build(:day_discount, from_time: (week_day.start_at + rand(4)),
                            to_time: (week_day.start_at + rand(5..8)), is_discount: true)

    end

      place.location   = location
      place.week_days  << week_days
      place.categories << category
      place.kitchens   << kitchen
      insert_default_menus(place)

      rand(1..15).times do
        review = FactoryGirl.build(:review, user_id: User.all.sample.id)
        MarkType.all.each { |mark_type| review.marks << FactoryGirl.build(:mark, mark_type_id: mark_type.id) }
        place.reviews << review
        place.notes   << FactoryGirl.build(:note)
        place.events  << FactoryGirl.build(:event)
      end
    puts "place add"
    end
  puts 'test stuff added successfully'
end

def insert_group_feature
  GroupFeature.all.map(&:destroy)
  FeatureItem.full_truncate
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
  MarkType.full_truncate
  %w(pricing service food ambiance noise\ level).each do |type|
    included = (type == 'noise level' ? false : true)
    MarkType.create(name: type, description: Faker::Lorem.sentence(10), included_in_overall: included)
  end
  puts 'mark types added successfully'
end

def insert_city
  City.full_truncate
  [{name: "Kyiv", slug: "kyiv"},{name: "Kharkiv", slug: "kharkiv"}, {name: "Odessa", slug: "odessa"},
  {name: "Dnepropetrivsk", slug: "dnepropetrivsk"}, {name: "Donetsk", slug: "donetsk"}, {name: "Lviv", slug: "lviv"}
  ].each do |city|
    City.create do |c|
      c.name = city[:name]
      c.slug = city[:slug]
      c.plural_name = city[:name]
    end.save!
  end
  puts 'cities added successfully'
end

def insert_default_place_pictures
  pictures_path = Rails.root.join('public', 'images', 'default_place_pictures', '*.{jpg, png, jpeg}')
  pictures = Dir.glob(pictures_path).map { |entry| File.new(entry)}
  Place.all.each do |place|
     pictures_clone = pictures.clone #for uniq images in place
     place.place_image = PlaceImage.new(data: pictures_clone.delete(pictures_clone.sample), is_main: true)
     rand(1..5).times { place.place_images << PlaceImage.new(data: pictures_clone.delete(pictures_clone.sample), is_main: false) }
  end
  puts 'place images added successfully'
end


def insert_slider
  pictures_path = Rails.root.join('public', 'images', 'slider', '*.{jpg, png, jpeg}')
  pictures = Dir.glob(pictures_path).map { |entry| File.new(entry)}
  Place.all.each do |place|
    place.slider = Slider.new(data: pictures.sample, is_main: true)
  end
end

def insert_default_reservations
  Reservation.full_truncate
  10.times do
    user        = User.all.sample
    place       = Place.all.sample
    reservation = Reservation.create_from_place_and_user(user, place)
    reservation.special_notes = Faker::Lorem.sentences(3).join(' ')
    reservation.time = DateTime.now + rand(-5...5).days
    reservation.persons = rand(1..5)
    reservation.save
  end
end

def insert_default_menus place
  place.place_menus << rand(1..5).times.map do
    place_menu = FactoryGirl.create(:place_menu, place_id: place.id)
    place_menu.place_menu_items << rand(1..5).times.map do
       FactoryGirl.create(:place_menu_item, place_menu_id: place_menu.id)
    end
    place_menu
  end
  place.save!
end

def insert_default_vote_types
  VoteType.full_truncate
  %w|helpful unhelpful|.each { |title| VoteType.create(title: title, description: Faker::Lorem.sentence)}
end

def create_pages
  Structure.full_truncate
  %w(ABOUT\ US FAQ JOBS RESTAURATEURS CONTACT Help).each do |name|
    Structure.create do |s|
      s.name = name
      s.position = 5
    end.save!
  end
end

def insert_notifications
  UserNotification.full_truncate
  ["Subscribe for news & updates", "Send reservation details on my email"].each_with_index do |name, index|
    UserNotification.create(title: name, position: index)
  end
end

insert_fake_users
#User.full_truncate
#insert_default_user('admin@adm.com', :admin)
#insert_default_user('user@usr.com')
#add_categories
#add_kitchens
#insert_mark_types
#add_test_stuff
#insert_default_place_pictures
#insert_group_feature
#insert_city
#insert_default_reservations
#insert_default_vote_types
#insert_slider
#create_pages
#insert_notifications
#LetterSeed.insert_letters
