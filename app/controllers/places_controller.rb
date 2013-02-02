#coding: utf-8
class PlacesController < ApplicationController
  before_filter :find_place, only: [:show, :more, :set_unset_favorite]

  def show
    @date = params[:reserve_date] || Date.today.strftime('%d/%m/%Y')
    @location = @place.lat_lng
    @special_offers =  @place.day_discounts.special
    if signed_in?
      @review = Review.new(reviewable_id: @place.id, reviewable_type: Place.name)
      @review.marks.build
    end
    @stuff_for_share = { title: @place.title, link: place_url(@place), description: "test description",
                         picture: root_url + @place.place_image.url(:slider).sub('/','') }
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

  def set_unset_favorite
    #raise @place.inspect
    if signed_in? && @place
      already_favorite = current_user.user_favorite_places.pluck(:place_id).include? @place.id
      if already_favorite
        current_user.user_favorite_places.find_by_place_id(@place.id).destroy
      else
        current_user.favorite_places << @place
        current_user.save
      end
    end
    render nothing: true
  end


  def more
    reviews = @place.reviews.paginate(:page => params[:page])
    respond_to do |format|
      format.json { render json: reviews.map(&:for_mustache) }
    end
  end



  private

  def find_place
    @place = Place.find Place.deparam(params[:id])
  end


end
