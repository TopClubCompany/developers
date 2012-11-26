module Users::OmniauthCallbacksHelper

  def get_city_from_ip
    struct = Utils::Geoip::GeoipDb.search(request.remote_ip)
    if struct
      struct.city_name.present? ? struct.city_name : struct.country_name
    else
      ""
    end
  end

end
