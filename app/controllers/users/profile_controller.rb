class Users::ProfileController < ApplicationController
  before_filter :authenticate_user!

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

  def edit_settings

  end

  def my_reservations

  end

  def show_reservation

  end

  def edit_reservation

  end

  def update_settings
    #user.password = params[:user][:password].present? ?  params[:user][:password] : current_user.password
    if current_user.update_attributes(params[:user])
      redirect_to settings_profile_path(current_user.id)
      sign_in(current_user, by_pass: true)
    else
      render action: 'edit_settings'
    end
  end

end
