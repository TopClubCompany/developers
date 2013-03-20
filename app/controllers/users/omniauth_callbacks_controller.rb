# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < ApplicationController

  def auth
    data = Account.get_data_from_callback request.env["omniauth.auth"]
    #raise data.inspect
    if data[:provider] == 'facebook'
      facebook_user = FbGraph::User.me(data[:token]).fetch
      facebook_friends = facebook_user.friends.map{ |friend| {name: friend.name, id: friend.identifier  } }
      #raise facebook_friends.to_yaml
    end
    if data[:provider] == 'vkontakte'
      vk_user = VkontakteApi::Client.new(data[:token])
      vk_user.users.get(uid: data[:uid]).first
      fields = [:first_name, :last_name, :uid, :photo]
      vk_friends = []
      vk_user.friends.get(fields: fields) do |friend|
        vk_friends << {name: "#{friend.first_name} #{friend.last_name}", id: friend.uid}
      end
      #raise vk_friends.inspect
    end
    if session[:redirect_aut_path].present? && current_user.present?
      merge_from_account(data, current_user.email)
    else
      data[:email].present? ? auth_with_email(data) : auth_without_email(data)
    end
  end

  [:facebook, :vkontakte, :google, :twitter].each { |provider| alias_method provider, :auth }

  def enter_email
    data =  session[:user_data]
    email = params[:email]
    return merge(data, email) if params[:merge]
    check_email(email, data) unless email.nil?
    redirect_to root_path, flash: { error: "You try to access to admin page"} unless data.present?
  end

  def destroy_user_session
    sign_out current_user
    redirect_to root_path
  end

  def confirm_account
    token = params[:token]
    response = AccountEmailConfirmation.check_token(token)
    response.kind_of?(User) ? auth_user(response) : (redirect_to root_path, flash: { notice: response })
  end

  def user_registration
    user = params[:user]
    #raise user.to_yaml
    user[:birthday] = format_birthday(user)
    avatar = user.delete(:avatar)
    user[:password_confirmation] = user[:password]
    @user = User.new(user).activate
    @user.skip_confirmation! #remove for normal registration with confirm email
    if @user.save
      (@user.avatar = Avatar.new(data: avatar)) if avatar
      auth_user @user
    else
      redirect_to :back, flash: { error: @user.errors.full_messages.join(', ') }
    end
  end

  def failure
    redirect_to root_path, :flash => {:error => "Could not log you in. #{params[:message]}"}
  end

  def passthru
    redirect_to root_path, :flash => {:error => "Could not find social"}
  end

  private

  def merge(data, email)
    if (user = User.find_by_email(email)).present? && !user.accounts.pluck(:provider).include?(data[:provider])
      data[:email] = email
      send_letter_for_confirm_email(data)
    else
      redirect_to enter_email_path(email.gsub('.','#')), flash: { error: "Already exist user with that email and social provider" }
    end
  end

  def merge_from_account(data, email)
    data[:email] = email
    Account.create_or_find_by_oauth_data data
    redirect_to session[:redirect_aut_path]
  end

  def send_letter_for_confirm_email(data)
    token = AccountEmailConfirmation.generate_email_confirm(data).confirmation_token
    AccountMailer.confirm_email(data[:email], token).deliver
    redirect_to root_path, flash: { notice: "the letter with confirm information send on your email" }
  end

  def auth_without_email data
    account = Account.find_by_uid_and_provider((data[:id] or data[:uid]), data[:provider]).last
    (account.present? && account.email.present?) ? auth_user(account.user) : get_user_email(data)
  end

  def auth_with_email data
    user = Account.create_or_find_by_oauth_data data
    auth_user user
  end

  def auth_user user
    session[:user_data] = nil
    sign_in user
    return_path = if session[:return_path].present? && !session[:return_path].include?("user_registration")
                    session[:return_path]
                  else
                    root_path
                  end
    redirect_to return_path
  end

  def get_user_email data
    session[:user_data] = data
    redirect_to enter_email_path, flash: { notice: 'To finish creation of account - need to enter email' }
  end

  def check_email email, data
    if User.find_by_email(email).nil?
      data[:email] = email
      #send_letter_for_confirm_email(data) #uncoment for normal registration with confirm email
      auth_with_email data
    else
      redirect_to enter_email_path(email.gsub('.','#')), flash: { error: "Already exist user with that email" }
    end
  end

  def format_birthday(hash_date)
    3.times.map { |n| hash_date.delete("birthday(#{n + 1}i)") }.reverse.join('.')
  end

end
