class ExploreController < ApplicationController

  def index
    @places = Place.best_places(6, city: current_city)
    @new_place = Place.new_places(6, city: current_city)
    @tonight_available = Place.tonight_available(6, city: current_city)
  end


  def change_city

  end


end
