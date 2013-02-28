class ReservationsController < ApplicationController

  def new_reservation
    @persons = params[:amount_of_person]
    @place   = Place.find(params[:place_id])
    @date = DateTime.parse("#{params[:date]} #{params[:time].gsub(/[hm=]/,'').gsub('&',':')}")
    @options = {:reserve_date => params[:date], :reserve_time => params[:time]}
    @special_offers = Place.today_discount(@place.discounts_index, @options).compact
    @reservation = Reservation.create_from_place_and_user(current_user, @place)
    redirect_to new_user_session_path and return unless @reservation.present?
    @reservation.persons = @persons.to_i
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
      send_messages(reservation)
      redirect_to reservation_confirmed_path(reservation.id)
    else
      redirect_to new_reservation_path(@reservation), flash: { error: @reservation.errors.full_messages.join(', ') }
    end
  end

  def send_messages(reservation)
    options = {reservation_path: show_profile_reservation_path(current_user.id, reservation.id),
               place_path: place_path(reservation.place),
               edit_reservation_path: edit_profile_reservation_path(current_user.id, reservation.id),
               cancel_reservation_path: cancel_profile_reservation_path(current_user.id, reservation.id)}
    [1, 3].each do |type|
      text, caption = ::Utils::LetterParser.parse_params(reservation.to_mail(options).merge({letter_type: type}))
      if type == 3
        AccountMailer.new_reservation(reservation.email, caption, text).deliver
      else
        Utils::Soap::TurboSms.send_sms(reservation.phone, text) if reservation.phone
      end
    end
  end

end
