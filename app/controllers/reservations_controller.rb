class ReservationsController < ApplicationController

  def new_reservation
    date = params[:date].match /(?<day>\d+)-(?<month>\d+)-(?<year>\d+)/
    time = params[:time].match /h=(?<hour>\d+)&m=(?<minutes>\d+)/

    @persons = params[:amount_of_person]
    @place   = Place.find_by_id(params[:place_id])
    @date    = DateTime.new(date[:year].to_i, date[:month].to_i, date[:day].to_i,
                            time[:hour].to_i, time[:minutes].to_i)
    @reservation = Reservation.new(first_name: current_user.try(:first_name), last_name: current_user.try(:last_name),
                                  phone: current_user.try(:phone), user_id: current_user.try(:id), place_id: @place.id,
                                  email: current_user.try(:email))
  end

  def reservation_confirmed
    @reservation = Reservation.find_by_id(params[:reservation_id])
    @place = @reservation.try(:place)
    @date  = DateTime.parse(@reservation.try(:time))
    redirect_to root_path, flash: { error: 'no such reservation' } unless @reservation && @place
  end


  def complete_reservation
    reservation = Reservation.new(params[:reservation])

    if reservation.save
      AccountMailer.new_reservation(reservation.email, reservation.id).deliver
      Utils.Soap.TurboSms.send_sms(reservation.phone, "#{reservation.id} You id for reserv") if reservation.phone
      redirect_to reservation_confirmed_path(reservation.id)
    else
      redirect_to new_reservation_path(@reservation), flash: { error: @reservation.errors.full_messages.join(', ') }
    end
  end

end
