class ExploreController < ApplicationController

  def index
    @places = Place.best 6
  end


end
