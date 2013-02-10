#coding: utf-8
class PlacesController < ApplicationController
  before_filter :find_place, only: [:show, :more, :set_unset_favorite]
  before_filter :find_time, only: [:show]

  def show
    @date = params[:reserve_date] || Date.today.strftime('%d/%m/%Y')
    @location = @place.lat_lng
    @special_offers =  @place.day_discounts.special
    reviews = @place.reviews.includes(:votes, :marks)
    @reviews = case params[:sort_by]
                 when 'date'
                   reviews.order('created_at')
                 when 'usefulness_count'
                   reviews.sort { |a,b| b.votes.count - a.votes.count }
                 when 'overall_mark'
                   reviews.sort {|a,b| b.avg_mark - a.avg_mark}
                 else
                   reviews
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
    reviews = @place.reviews#.paginate(page: params[:page], per_page: params[:size])
    respond_to do |format|
      format.json { render json: reviews.map(&:for_mustache) }
    end
  end



  private

  def find_place
    @place = Place.find Place.deparam(params[:id])
  end

  def find_time
    if params[:reserve_date].present && params[:reserve_time].present?
      place = {}
      wday = PlaceUtils::PlaceTime.wday(DateTime.parse(options[:reserve_date]).wday)
      time = Time.parse(options[:reserve_time])
      @place.week_days.where(:day_type_id => wday).each do |week_day|
        place["week_day_#{wday}_start_at"] = week_day.start_at.to_s.split(".").join(":")
        place["week_day_#{wday}_end_at"] = week_day.end_at.to_s.split(".").join(":")
      end
      @filtered_time = Place.order_time(palce, time, wday)
    end

  end


end
