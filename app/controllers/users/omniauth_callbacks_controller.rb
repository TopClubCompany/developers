# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < ApplicationController

  def auth
    data = Account.get_data_from_callback request.env["omniauth.auth"]
    data[:email].present? ? auth_with_email(data) : auth_without_email(data)
  end

  [:facebook, :vkontakte, :google, :twitter].each { |provider| alias_method provider, :auth }

  def enter_email
    data =  session[:user_data]
    email = params[:email]
    check_email(email, data) unless email.nil?
    redirect_to root_path, flash: { error: "You try to access to admin page"} unless data.present?
  end

  def destroy_user_session
    sign_out current_user
    redirect_to root_path
  end


  private

  def auth_without_email data
    account = Account.find_by_uid_and_provider((data[:id] or data[:uid]), data[:provider])
    account.present? ? auth_user(account.user) : get_user_email(data)
  end

  def auth_with_email data
    user = Account.create_or_find_by_oauth_data data
    auth_user user
  end

  def auth_user user
    session[:user_data] = nil
    sign_in user
    redirect_to root_path, flash: { success: 'Successfully sign in' }
  end

  def get_user_email data
    session[:user_data] = data
    redirect_to enter_email_path, flash: { notice: 'To finish creation of account - need to enter email' }
  end

  def check_email email, data
    if User.find_by_email(email).nil?
      data[:email] = email
      user = Account.create_or_find_by_oauth_data data
      auth_user user
    else
      redirect_to enter_email_path, flash: { error: "Already exist user with that email" }
    end
  end

end
