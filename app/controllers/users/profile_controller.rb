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
        return (render action: 'invite_friends', falsh: { error: "some email(s) don't valid"} )
      end
    end
    emails.each do |email|
      AccountMailer.send_invitation(email, link, sender, message).deliver
    end
  end

end
