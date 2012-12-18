#coding: utf-8

class PlacesController < ApplicationController
  def show
    @place = Place.find params[:id]
  end

  def index
    if request.xhr?
      render :partial => 'places', :content_type => 'text/html; charset=utf-8'
    end
  end

  def set_location
    session[:city] = params[:location_slug]
    redirect_to  :back
  end


end
