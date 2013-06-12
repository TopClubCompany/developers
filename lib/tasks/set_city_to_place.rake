task :set_city => :environment do
  Place.all.each do |place|
    place.location.send(:set_city_to_place) if place.location
  end
end