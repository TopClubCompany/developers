task :import_to_xml => :environment do
  xml = Builder::XmlMarkup.new( :indent => 2 )
  xml.instruct! :xml, :encoding => "ASCII"

  Place.all.each do |place|
    xml.offer do |p|
      p.id place.id
      p.name
      p.
    end



    place.location.send(:set_city_to_place) if place.location
  end
end