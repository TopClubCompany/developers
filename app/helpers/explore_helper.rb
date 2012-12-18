module ExploreHelper

  def slider_place_image place, type = :slider_url
    place.images.detect { |image| image.is_main }.try(type.to_sym) if place.images
  end

end
