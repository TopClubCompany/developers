class Users::ProfileController < ApplicationController
  before_filter :authenticate_user!

  include ReservationsHelper

  def show

  end

  def invite_friends

  end


  def send_email_invitation
    emails  = params[:emails].split("\r\n")
    message = params[:message]
    link    = root_url #test link
    sender  = current_user.full_name
    emails.each do |email|
      unless email =~ Devise.email_regexp
        flash[:error] = "some email(s) don't valid"
        return (render action: 'invite_friends')
      end
    end
    emails.each do |email|
      AccountMailer.send_invitation(email, link, sender, message).deliver
    end
    flash[:success] = "invated!"
    redirect_to profile_path(current_user)
  end

  def self_reviews

  end

  def settings

  end

  def favourites
    @places = current_user.user_favorite_places
  end

  def edit_settings
    session[:redirect_aut_path] = edit_settings_profile_path(current_user.id)
  end

  def my_reservations

  end

  def disconnected
    current_user.accounts.by_type(params[:type]).first.try(:destroy)
    redirect_to edit_settings_profile_path(current_user.id)
  end

  def show_reservation
    @reservation = Reservation.find_by_id(params[:reservation_id])
    @place       = @reservation.place
  end

  def edit_reservation
    @reservation = Reservation.find_by_id(params[:reservation_id])
    @place       = @reservation.place
    unless current_user.id == @reservation.id
      redirect_to root_path
    end
  end

  def update_settings
    if current_user.update_attributes(params[:user])
      redirect_to edit_settings_profile_path(current_user.id)
      sign_in(current_user, by_pass: true)
    else
      render action: 'edit_settings'
    end
  end

  def update_reservation
    #raise params.to_yaml
    reservation = Reservation.find_by_id(params[:reservation_id])
    if current_user.reservations.map(&:id).include? reservation.id
      time = DateTime.strptime(params[:reservation].delete(:date) + ' ' + params[:reservation].delete(:time), "%D %I:%M %p")
      params[:reservation][:time] = time
      if reservation.update_attributes(params[:reservation])
        send_messages(reservation, [7])
        redirect_to show_profile_reservation_path(reservation.user.id, reservation.id), flash: {success: 'reservation updated successfully'}
      else
        render action: 'edit_reservation'
      end
    else
      redirect_to root_path
    end
  end

  def cancel_reservation
    reservation = Reservation.find_by_id(params[:reservation_id])
    if current_user.id == reservation.user_id
      send_messages(reservation, [5,6])
      reservation.destroy
      redirect_to my_reservations_profile_path(current_user.id)
    else
      redirect_to root_path
    end

  end

end
