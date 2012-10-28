# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require_relative "../spec/blueprints"


def insert_user(email, admin=true)
  User.full_truncate
  password = Rails.env.production? ? Devise.friendly_token.first(6) : (1..6).to_a.join
  admin = User.new(:email => email,
                   :password => password, :password_confirmation => password)
  admin.login = 'admin' if admin.respond_to?(:login)
  admin.user_role_type = admin ? UserRoleType.admin : UserRoleType.default
  admin.trust_state = UserState.active.id
  admin.skip_confirmation!
  admin.save!
  puts "Admin: #{admin.email}, #{admin.password}"
end

insert_user('admin@adm.com')
insert_user('fd@adm.com', false)

#user = User.make! first_name: 'Happy user', email: 'admin@example.com', password: 'password', password_confirmation: 'password'
#other_user = User.make!

23.times do
  category  = Category.make!
  kitchen   = Kitchen.make!
  10.times do
    place = Place.make!
    place.categories << category
    place.kitchens << kitchen
    3.times do
      Note.make!   place: place
      Review.make! place: place, user: User.last
      Event.make!  place: place
    end

  end
end

#10.times do
#  s = Selection.make! user: User.first
#  rand_place = Place.find_by_id rand(Place.last.id)
#  if (rand_place.id.to_i - 10) > 0
#    start_place_id = rand_place.id.to_i - 10
#    places = [start_place_id..rand_place.id]
#    Place.where(id: places).all.map{ |pl| s.places << pl}
#  end
#end