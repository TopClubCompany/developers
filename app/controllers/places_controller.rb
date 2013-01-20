#coding: utf-8
class PlacesController < ApplicationController
  def show
    @place = Place.find params[:id]
    @location = (Place.find params[:id]).lat_lng
    @special_offers =  @place.day_discounts.where(is_discount: false)
  end

  def index
  end

  def set_location
    session[:city] = params[:location_slug]
    if (city = City.find_by_slug(session[:city])) && current_user
      current_user.update_attribute(:city, city)
    end
    redirect_to  :back
  end


end
