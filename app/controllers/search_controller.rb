class SearchController < ApplicationController
  def index
    @result = Place.search(params)
    respond_to do |format|
      format.json do
        render :json => @result
      end
      format.html do
        render 'search/index'
      end
    end
  end

  def show

  end

  def get_more
    type = params[:type]
    more_objects = case type
      when 'category'
        Category.with_translations.offset(4).limit(10000)
      when 'kitchen'
        Kitchen.with_translations.offset(4).limit(10000)
      else
        {}
      end
    render :json => more_objects.to_json
  end


  private

  #point = MultiGeocoder.geocode options[:where]
  #if point.success
  #  distance = options[:distance].present? ? options[:distance].values.map(&:to_f).max : 10
  #  @filters << { geo_distance: { distance: "#{distance}km", lat_lng: @current_point } }
  #else
  #  @filters << { geo_distance: { distance: '1km', lat_lng: @current_point } }
  #end

  #if options[:what].present? and options[:what].size > 0
  #  what = options[:what].split(' ').join(' OR ')
  #  @query = { query_string: { fields: ['address', 'description', 'name^5'], query: what, use_dis_max: true } }
  #else
  #  @query = { match_all: {} }
  #end


end
