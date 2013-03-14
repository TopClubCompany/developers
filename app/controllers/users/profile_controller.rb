class Users::ProfileController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user, :only => [:show, :settings, :invite_friends, :favourites, :edit_settings,
                                      :update_settings, :reservations]
  before_filter :set_breadcrumbs_front

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
    unless current_user.id == @user.id
      redirect_to root_path
    end
  end

  def favourites
    @places = current_user.user_favorite_places
  end

  def edit_settings
    session[:redirect_aut_path] = edit_settings_profile_path(current_user.id)
  end

  def reservations

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
    unless current_user.id == @reservation.user_id
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
    reservation = Reservation.find_by_id(params[:reservation_id])
    if current_user.reservations.map(&:id).include? reservation.id
      time = DateTime.parse(params[:reservation].delete(:date) + ' ' + params[:reservation].delete(:time))
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
      redirect_to reservations_profile_path(current_user.id)
    else
      redirect_to root_path
    end

  end

  protected

  def set_breadcrumbs_front
    path = request.env['PATH_INFO'].to_s
    @breadcrumbs_front = ["<a href=#{profile_path(current_user)}>#{I18n.t('breadcrumbs.profile')}&nbsp</a>"]

    if find_tab(path).present?
      @breadcrumbs_front << ["<a href=#{with_locale(path)}>#{find_tab(path)}&nbsp</a>"]
    end
  end

  private
  def find_tab(path)
    path = I18n.t("user_sidebar.#{path.split('/').last}")
    if path.include?("translation missing")
      ""
    else
      path
    end
  end

  def find_user
    @user = User.find(params[:id])
    unless current_user.id == @user.id
      redirect_to root_path
    end
  end

end
