#coding: utf-8

class PlacesController < ApplicationController
  def show
    @place = Place.find params[:id]
    @location = (Place.find params[:id]).lat_lng
  end

  def index
    if request.xhr?
      render :partial => 'places', :content_type => 'text/html; charset=utf-8'
    end
  end

  def set_location
    session[:city] = params[:location_slug]
    if City.find_by_slug(session[:city]) && current_user
      current_user.update_attribute(:city, City.find_by_slug(session[:city]))
    end
    redirect_to  :back
  end


end
