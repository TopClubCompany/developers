require_relative "../spec/blueprints"


def insert_default_user(email, admin = true)
  password            = Rails.env.production? ? Devise.friendly_token.first(6) : (1..6).to_a.join
  user                = User.new(email: email, password: password, password_confirmation: password)
  user.login          = admin ? 'admin' : 'user'
  user.user_role_type = admin ? UserRoleType.admin : UserRoleType.default
  user.trust_state    = UserState.active.id

  user.skip_confirmation!
  user.save!
  puts "#{admin ? 'Admin: ' : 'User: '}#{email}, #{password}"
end

#user = User.make! first_name: 'Happy user', email: 'admin@example.com', password: 'password', password_confirmation: 'password'
#other_user = User.make!
def add_test_stuff
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
end


User.full_truncate
insert_default_user('admin@adm.com')
insert_default_user('user@usr.com', false)
add_test_stuff

#10.times do
#  s = Selection.make! user: User.first
#  rand_place = Place.find_by_id rand(Place.last.id)
#  if (rand_place.id.to_i - 10) > 0
#    start_place_id = rand_place.id.to_i - 10
#    places = [start_place_id..rand_place.id]
#    Place.where(id: places).all.map{ |pl| s.places << pl}
#  end
#end