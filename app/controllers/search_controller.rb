class SearchController < ApplicationController

  before_filter :search, only: [:index, :show]

  def index
    respond_to do |format|
      format.json do
        render :json => {result: @result.map{|e| Place.for_mustache(e, params) },
                         total: @result.total}
      end
      format.html do
        render 'search/index'
      end
    end
  end

  def show
    @category = Category.find(params[:id])
    set_gon_params
    respond_to do |format|
      format.html do
        render action: :index
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
    @result = Place.search(params.merge(city: current_city, current_point: cookies[:current_point]))
  end

  def set_gon_params
    gon.category = [@category.id]
  end

end
