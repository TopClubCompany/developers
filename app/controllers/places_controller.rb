#coding: utf-8
class PlacesController < ApplicationController
  before_filter :find_place, only: [:show, :more]

  def show
    @date = params[:reserve_date] || Date.today.strftime('%d/%m/%Y')
    time = Time.parse(params[:reserve_time]) rescue Time.now
    minutes = %w(00 30)[time.min / 30]
    @time = {:h => time.hour.to_s, :m => minutes}
    @location = @place.lat_lng
    @special_offers =  @place.day_discounts.special
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

  def more
    reviews = @place.reviews.paginate(:page => params[:page])
    respond_to do |format|
      format.json { render json: reviews.map(&:for_mustache) }
    end
  end

  private

  def find_place
    @place = Place.find params[:id]
  end


end
