module ExploreHelper

  def slider_place_image place, type = :slider_url
    place.images.detect { |image| image.is_main }.try(type.to_sym) if place.images
  end

  def support_phone
    if current_city
      City.find(current_city).support_phone
    else
      ""
    end
  end

end
