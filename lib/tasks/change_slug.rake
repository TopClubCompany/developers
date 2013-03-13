task :change_slug => :environment do
  Place.all.each do |place|
    place.slug = Utils::I18none::Alphavit.to_en(place.name).parameterize
    place.save!
  end
end
