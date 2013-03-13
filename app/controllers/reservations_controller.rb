class ReservationsController < ApplicationController

  include ReservationsHelper

  def new_reservation
    @persons = params[:amount_of_person]
    @place   = Place.find(params[:place_id])
    time = params[:time].gsub(/[hm=]/,'').gsub('&',':')
    time = Place.en_to_time(time)
    @date = DateTime.parse("#{params[:date]} #{time}")
    @options = {:reserve_date => params[:date], :reserve_time => params[:time]}
    @special_offers = Place.today_discount(@place.discounts_index, @options).compact
    @reservation = Reservation.create_from_place_and_user(current_user, @place)
    redirect_to new_user_session_path and return unless @reservation.present?
    @reservation.persons = @persons.to_i
  end

  def reservation_confirmed
    @reservation = Reservation.find(params[:reservation_id])
    if current_user.id == @reservation.user_id
      @place = @reservation.try(:place)
      @date  = @reservation.time
      redirect_to root_path, flash: { error: 'no such reservation' } unless @reservation && @place
    else
      redirect_to root_path
    end
  end


  def complete_reservation
    reservation = Reservation.new(params[:reservation])
    if reservation.save
      add_points
      send_messages(reservation, [1,2,3,4,8])
      redirect_to reservation_confirmed_path(reservation.id)
    else
      redirect_to new_reservation_path(@reservation), flash: { error: @reservation.errors.full_messages.join(', ') }
    end
  end

  def available_time
    place = Place.find(params[:place_id])
    current_day = params[:reserve_date].present? ? DateTime.parse(params[:reserve_date]).wday : DateTime.now.wday
    current_day = PlaceUtils::PlaceTime.wday(current_day)
    respond_to do |format|
      format.json do
        render :json => {times: Reservation.available_time(current_day, place)}
      end
    end
  end

  def print
    @reservation = Reservation.find(params[:id])
    if current_user.id == @reservation.user_id
      @place = @reservation.try(:place)
      @date  = @reservation.time
      @discount = @place.today_discount_with_time(@date).max{|x| x.discount}
      redirect_to root_path, flash: { error: 'no such reservation' } unless @reservation && @place
      render "print", layout: "print"
    else
      redirect_to root_path
    end

  end

  private

  def add_points
    current_user.points =+ Figaro.env.POINTS.to_f
    current_user.save
  end

end
