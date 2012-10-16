class ExploreController < ApplicationController

  def index
    @categories = Category.order :created_at
    @reviews    = Review.order :created_at
    @selections = Selection.order :created_at
    @recomended_places = Place.recomended_for(current_user).first 3

    styx_initialize_with point: @current_point

  end

end
