#coding: utf-8

class PlacesController < ApplicationController
  include Geokit::Geocoders
  include PlacesHelper

  before_filter :init_filters, only: [:index]

  def update
    @place = Place.find params[:id]

    if @place.update_attributes(params[:place])
     redirect_to place_path(@place)
    end
  end

  def show
    @place = Place.find params[:id]
    #styx_initialize_with point:           @place.lat_lng,
    #                     rating:          @place.rating,
    #                     rating_url:      rate_place_path(@place),
    #                     can_be_rated:    (@place.rated_users.exclude?  current_user.id.to_s),
    #                     can_be_favorite: (@place.in_favorites.exclude? current_user.id.to_s),
    #                     can_be_planned:  (@place.in_planes.exclude?    current_user.id.to_s),
    #                     can_be_visited:  (@place.in_visited.exclude?   current_user.id.to_s)
  end

  def index
    @places = search (parse_filters_from params)
    if @total_places > (Place::PER_PAGE * @page_num)
      @next_page_path = places_path params.merge page: (@page_num + 1)
    end

    styx_initialize_with point: @current_point,
                         places: @places.map{ |p| [p.lat_lng, p.category.icon] }

    if request.xhr?
      render :partial => 'places', :content_type => 'text/html; charset=utf-8'
    end
  end

  def rate
    @place = Place.find params[:id]
    result = @place.rate!(params[:place][:rating].to_i, current_user.id) if params[:place][:rating].present?
    render text: result, :content_type => 'text/html; charset=utf-8'
  end

  # TODO make dynamic methods here
  def favorite
    @place = Place.find params[:id]
    result = @place.favorite_for current_user.id
    render json: ['favorite', result]
  end

  def planned
    @place = Place.find params[:id]
    result = @place.planned_by current_user.id
    render json: ['planned', result]
  end

  def visited
    @place = Place.find params[:id]
    result = @place.visited_by current_user.id
    render json: ['visited', result]
  end

  private
    def search(options={})
      point = MultiGeocoder.geocode options[:where]

      if point.success
        distance = options[:distance].present? ? options[:distance].values.map(&:to_f).max : 10   # TODO remove '*100'
        @current_point = point.ll
        @filters << { geo_distance: { distance: "#{distance}km", lat_lng: @current_point } }
      else
        @filters << { geo_distance: { distance: '1km', lat_lng: @current_point } }
      end

      if options[:what].present? and options[:what].size > 0
        what = options[:what].split(' ').join(' OR ')
        @query = { query_string: { fields: ['address', 'description', 'name^5'], query: what, use_dis_max: true } }
      else
        @query = { match_all: {} }
      end

      # dry this to three lines
      if options[:kitchen]
        @filters << {query: {query_string: {query: "kitchen_id:#{options[:kitchen].keys.join(' OR ')}"}}}
      end

      if options[:category]
        @filters << {query: {query_string: {query: "category_id:#{options[:category].keys.join(' OR ')}"}}}
      end

      if options[:avgbill]
        @filters << {query: {query_string: {query: "avgbill:#{options[:avgbill].keys.join(' OR ')}"}}}
      end

      query = Tire.search 'places', query: { filtered: {
                              query: @query,
                              filter: { and: @filters }
                          } },
                          from: (@page_num - 1) * Place::PER_PAGE,
                          size: Place::PER_PAGE
      @total_places = query.results.total
      query.results.map{ |r| r.load }
    end

    def init_filters
      @filters = []
      @categories = Category.order :created_at
      @kitchens   = Kitchen.order  :created_at
      @entities   = [
          { label: 'Люди',          value: 'Люди'         },
          { label: 'Фоторепортажи', value: 'Фоторепортажи'},
          { label: 'Новости',       value: 'Новости'      },
          { label: 'События',       value: 'События'      },
          { label: 'Места',         value: 'Места'        }
      ]
      @distances  = Filter.all_for 'distance'
      @avgbills   = Filter.all_for 'avgbill'
      @recomended_places = Place.recomended_for(current_user).first 5
      @what, @where = params[:what].try(:strip), params[:where].try(:strip)
      @page_num = (params[:page] || 1).to_i
    end
end
