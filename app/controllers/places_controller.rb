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




end
