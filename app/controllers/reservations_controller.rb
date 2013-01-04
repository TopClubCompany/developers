class ReservationsController < ApplicationController

  def new_reservation
    @persons = params[:amount_of_person]
    @place   = Place.find_by_id(params[:place_id])
    @date = DateTime.parse("#{params[:date]} #{params[:time].gsub(/[hm=]/,'').gsub('&',':')}")
    @reservation = Reservation.create_from_place_and_user(current_user, @place)
  end

  def reservation_confirmed
    @reservation = Reservation.find(params[:reservation_id])
    @place = @reservation.try(:place)
    @date  = DateTime.parse(@reservation.try{|res| res.time.to_s})
    redirect_to root_path, flash: { error: 'no such reservation' } unless @reservation && @place
  end


  def complete_reservation
    reservation = Reservation.new(params[:reservation])
    if reservation.save
      AccountMailer.new_reservation(reservation.email, reservation.id).deliver
      Utils::Soap::TurboSms.send_sms(reservation.phone, "#{reservation.id} You id for reserv") if reservation.phone
      redirect_to reservation_confirmed_path(reservation.id)
    else
      redirect_to new_reservation_path(@reservation), flash: { error: @reservation.errors.full_messages.join(', ') }
    end
  end

end
