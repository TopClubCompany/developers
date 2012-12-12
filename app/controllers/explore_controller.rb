class ExploreController < ApplicationController

  def index
    @places = Place.best_places(6, city: current_city)
  end


  def change_city

  end


end
