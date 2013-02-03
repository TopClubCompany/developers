#coding: utf-8
class PlacesController < ApplicationController
  before_filter :find_place, only: [:show, :more, :set_unset_favorite]

  def show
    @date = params[:reserve_date] || Date.today.strftime('%d/%m/%Y')
    @location = @place.lat_lng
    @special_offers =  @place.day_discounts.special
    @reviews = case params[:sort_by]
                 when 'date'
                   @place.reviews.order('created_at')
                 when 'usefulness_count'
                   reviews = @place.reviews.map { |review|  {id: review.id, votes_count: review.votes.count} }
                   reviews = reviews.sort {|a,b| b[:votes_count] - a[:votes_count]}
                   reviews.map { |review| Review.find(review[:id]) }
                 when 'overall_mark'
                   reviews = @place.reviews.map { |review|  {id: review.id, overall_mark: review.avg_mark} }
                   reviews = reviews.sort {|a,b| b[:overall_mark] - a[:overall_mark]}
                   reviews.map { |review| Review.find(review[:id]) }
                 else
                   @place.reviews

    end
    if signed_in?
      @review = Review.new(reviewable_id: @place.id, reviewable_type: Place.name)
      @review.marks.build
    end
    @stuff_for_share = { title: @place.title, link: place_url(@place), description: t('share.description'),
                         picture: @place.place_image ? root_url + @place.place_image.url(:slider).sub('/','') : root_url}
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
    #raise params.inspect
    reviews = @place.reviews#.paginate(page: params[:page], per_page: params[:size])
    #raise @place.reviews.inspect
    respond_to do |format|
      format.json { render json: reviews.map(&:for_mustache) }
    end
  end



  private

  def find_place
    @place = Place.find Place.deparam(params[:id])
  end


end
