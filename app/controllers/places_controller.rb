#coding: utf-8
class PlacesController < ApplicationController
  before_filter :find_place, only: [:show, :more, :set_unset_favorite]
  before_filter :find_page, only: :show
  before_filter :find_time, only: [:show]
  before_filter :set_breadcrumbs_front, only: :show

  def show
    @date = params[:reserve_date] || Date.today.strftime('%d/%m/%Y')
    @date = (Time.parse(@date) + 1.day).strftime("%d/%m/%Y") if @next_day
    @location = @place.lat_lng
    @special_offers = @place.day_discounts.special
    reviews = @place.reviews.includes(:votes, :marks)
    # For icon to be visible in production, we want root_url + "assets/pin.png" to be available from maps.googleapis domain
    @icon_url = CGI::escape(Rails.env.production? ? root_url + "/assets/pin.png" : "http://chrononsystems.com/wp-content/themes/toolbox/images/pin.png")
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
    if signed_in? && current_user.reservations.pluck(:place_id).include?(@place.id)
      @review = Review.new(reviewable_id: @place.id, reviewable_type: Place.name)
      @review.marks.build
    end
    @stuff_for_share = { title: @place.title, link: place_url(@place), description: t('share.description'),
                         picture: @place.place_image ? root_url + @place.place_image.url(:slider).sub('/','') : root_url}
  end


  def set_location
    session[:city] = params[:location_slug]
    if (city = City.find_by_slug(session[:city])) && current_user
      current_user.update_attribute(:city, city)
    end
    redirect_to  :back
  end

  def set_unset_favorite
    if signed_in? && @place
      already_favorite = current_user.user_favorite_places.pluck(:place_id).include? @place.id
      if already_favorite
        current_user.user_favorite_places.find_by_place_id(@place.id).destroy
      else
        current_user.favorite_places << @place
        current_user.save
      end
    end
    respond_to do |format|
      format.json { render json: {} }
      format.html do
        redirect_to  new_user_registration_path
      end
    end
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
    unless current_city.to_s == @place.city.slug.to_s
      url = request.url.sub(current_city.to_s, @place.city.slug.to_s)
      redirect_to url
    end
  end

  def find_page
    structure = Structure.with_position(::PositionType.place).first
    setting_meta_tags structure, @place.meta_tag
  end

  def find_time
    @filtered_time = nil
    if params[:reserve_date].present? && params[:reserve_time].present?
      place = {}
      wday = PlaceUtils::PlaceTime.wday(DateTime.parse(params[:reserve_date]).wday)
      time = params[:reserve_time]
      time = Time.parse(Place.en_to_time(time))
      @place.week_days.where(:day_type_id => wday).each do |week_day|
        place["week_day_#{wday}"] = week_day.range_time
      end
      @filtered_time = Place.order_time(place, time, wday)
    end

  end

  def set_breadcrumbs_front
    super
    @breadcrumbs_front << ["<a href=#{with_locale("search")}>#{I18n.t('breadcrumbs.search')}</a>&nbsp"]
    @breadcrumbs_front << ["<a href=#{@place.place_path}>#{@place.title}</a>&nbsp"]
  end

end
