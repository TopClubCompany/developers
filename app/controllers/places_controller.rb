#coding: utf-8

class PlacesController < ApplicationController
  include Geokit::Geocoders
  include PlacesHelper

  def update
    @place = Place.find params[:id]

    if @place.update_attributes(params[:place])
     redirect_to place_path(@place)
    end
  end

  def show
    @place = Place.find params[:id]
  end

  def index
    if request.xhr?
      render :partial => 'places', :content_type => 'text/html; charset=utf-8'
    end
  end

  def rate
    @place = Place.find params[:id]
    result = @place.rate!(params[:place][:rating].to_i, current_user.id) if params[:place][:rating].present?
    render text: result, :content_type => 'text/html; charset=utf-8'
  end

  # TODO make dynamic methods here
  def favorite
    @place = Place.find params[:id]
    result = @place.favorite_for current_user.id
    render json: ['favorite', result]
  end

  def planned
    @place = Place.find params[:id]
    result = @place.planned_by current_user.id
    render json: ['planned', result]
  end

  def visited
    @place = Place.find params[:id]
    result = @place.visited_by current_user.id
    render json: ['visited', result]
  end

end
