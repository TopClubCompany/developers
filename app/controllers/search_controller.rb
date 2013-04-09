class SearchController < ApplicationController


  before_filter :search, only: [:index, :show]
  before_filter :find_page, only: [:index, :show]

  def index
    respond_to do |format|
      format.html do
        render 'search/index'
      end
      format.json do
        render :json => {result: @result.map{|e| Place.for_mustache(e, params) },
                         total: @result.total}
      end
    end
  end

  def show
    @category ||= Category.find(params[:id])

    proper_name = @category.plural_name
    set_gon_params
    respond_to do |format|
      format.html do
        render action: :index, :locals => {:type => proper_name}
      end
      format.json do
        render :json => {result: @result.map{|e| Place.for_mustache(e, params) },
                         total: @result.total}
      end

    end
  end


  def get_more
    type = params[:type]
    more_objects = case type
      when 'category'
        Category.children.offset(4).limit(10000)
      when 'kitchen'
        Kitchen.with_translations.offset(4).limit(10000)
      else
        {}
      end
    render :json => more_objects.to_json
  end


  private

  def search
    #raise I18n.locale.inspect
    @result = Place.search(params.merge!(city: current_city, current_point: cookies[:current_point], current_user: current_user))
    @geo_point_array = get_geo_points()
  end

  def set_gon_params
    gon.category = [@category.id]
  end

  def get_geo_points
    @result.map do |e|
      if e.lat_lng.present?
        lat_long = e.lat_lng.split(',')
        {lat: lat_long[0].to_f, lng: lat_long[1].to_f}
      else
        {lat: 0, lng: 0}
      end
    end
  end

  def set_breadcrumbs_front
    super
    @breadcrumbs_front << ["<a href=#{with_locale("search")}>#{I18n.t('breadcrumbs.search')}</a>&nbsp"]
    if params[:id].present?
      @category ||= Category.find(params[:id])
      @breadcrumbs_front << ["<a href=#{search_path(@category.slug)}>#{@category.name}</a>&nbsp"]
    end
  end


  def find_page
    if params[:id].present?
      structure = Structure.with_position(::PositionType.category).first
      setting_meta_tags structure, @category.meta_tag(City.find(current_city).name)
    else
      structure = Structure.with_position(::PositionType.search).first
      setting_meta_tags structure, {}
    end

  end

end
