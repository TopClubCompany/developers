require_relative "../spec/blueprints"


def insert_default_user(email, admin = true)
  password            = Rails.env.production? ? Devise.friendly_token.first(6) : (1..6).to_a.join
  user                = User.new(email: email, password: password, password_confirmation: password).generate_default_fields
  user.login          = admin ? 'admin' : 'user'
  user.user_role_type = admin ? UserRoleType.admin : UserRoleType.default
  user.activate.skip_confirmation!
  user.save!
  puts "#{admin ? 'Admin: ' : 'User: '}#{email}, #{password}"
end

#user = User.make! first_name: 'Happy user', email: 'admin@example.com', password: 'password', password_confirmation: 'password'
#other_user = User.make!
def add_test_stuff
  5.times do
    category  = Category.make!
    kitchen   = Kitchen.make!
    10.times do

      place = Place.create! do |pl|
        pl.name        = Faker::Company.name
        pl.description = Faker::Lorem.sentence
        pl.phone       = Faker::PhoneNumber.phone_number
        pl.url         = Faker::Internet.http_url
      end
      place.location = Location.create!({latitude:  Faker::Geolocation.lat, longitude: Faker::Geolocation.lng,
                                      locationable_id: place.id, locationable_type: 'Place'})
      place.save!

      place.categories << category
      place.kitchens << kitchen
      3.times do
        Note.make!   place: place
        Review.make! place: place, user: User.last
        Event.make!  place: place
      end

    end
  end
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


end

def insert_marks_and_reviews user
  (rand(5) + 1).times do
    place = Place.all.sample
    place.reviews << Review.new(user_id: user.id, content: 'placeholder', title: 'placeholder')
  end
  #user.reviews.each { |review| review.mark = Mark.new(food: (rand(5) + 1) }

end

def insert_mark_types
  %w(price services food).each do |type|
    MarkType.create do |mark_type|
      mark_type.name = type
    end.save!
  end
end

User.full_truncate
insert_default_user('admin@adm.com')
insert_default_user('user@usr.com', false)
add_test_stuff
insert_group_feature
insert_mark_types
#insert_marks_and_reviews(User.find_by_email('admin@adm.com'))

#10.times do
#  s = Selection.make! user: User.first
#  rand_place = Place.find_by_id rand(Place.last.id)
#  if (rand_place.id.to_i - 10) > 0
#    start_place_id = rand_place.id.to_i - 10
#    places = [start_place_id..rand_place.id]
#    Place.where(id: places).all.map{ |pl| s.places << pl}
#  end
#end
