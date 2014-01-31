if defined? Geokit

Geokit::default_units = :kms
Geokit::default_formula = :sphere

Geokit::Geocoders::proxy = nil
Geokit::Geocoders::NominatimGeocoder.server = "nominatim.openstreetmap.org/search"
Geokit::Geocoders::provider_order = [:nominatim]

end
