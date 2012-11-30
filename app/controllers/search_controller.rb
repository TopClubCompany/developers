class SearchController < ApplicationController

  def index
    @categories = Category.order :created_at
    @reviews    = Review.order :created_at
    @selections = Selection.order :created_at
    @recomended_places = Place.first 7

    lang = request.env['REQUEST_URI'].to_s.split('/')[0]
    p lang
    if lang.nil?
      @lang = 'en'
    elsif lang =~ /(ru|ua|en)/
      @lang = lang
    end
    #styx_initialize_with point: @current_point
    render :template => 'search/index'
  end

  def search

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


end
