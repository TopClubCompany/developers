class ExploreController < ApplicationController

  def index
    @places = Place.best_places 6
  end


end
