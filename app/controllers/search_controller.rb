class SearchController < ApplicationController

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
