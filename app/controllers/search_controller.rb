class SearchController < ApplicationController

  before_filter :init_filters, :only => :search


  def index

  end

  def search
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

    # dry this to three lines
    if params[:kitchen]
      @filters << {query: {query_string: {query: "kitchen_ids:#{params[:kitchen].keys.join(' OR ')}"}}}
    end

    if params[:category]
      @filters << {query: {query_string: {query: "category_ids:#{params[:category].keys.join(' OR ')}"}}}
    end

    if params[:avg_bill]
      @filters << {query: {query_string: {query: "avg_bill:#{params[:avg_bill].keys.join(' OR ')}"}}}
    end

    query = Tire.search 'places', query: { filtered: {
        query: @query,
        filter: { and: @filters }
    } },
                        from: (@page_num - 1) * 25,
                        size: 25
    @total_places = query.results.total
    query.results.map{ |r| r.load }

    render :json => query.results.to_json
  end

  def show

  end

  def get_more
    type = params[:type]
    more_objects = case type
      when 'category'
        Category.with_translations.offset(4)
      when 'kitchen'
        Kitchen.with_translations.offset(4)
      else
        {}
      end
    render :json => more_objects.to_json
  end


  private

  def init_filters
    @filters = []
    @categories = Category.order :created_at
    @kitchens   = Kitchen.order  :created_at
    #@distances  = Filter.all_for 'distance'
    @avgbills   = Filter.all_for 'avg_bill'
    @page_num = (params[:page] || 1).to_i
  end


end
