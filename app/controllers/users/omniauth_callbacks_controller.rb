# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < ApplicationController

  def auth
    data = get_data_from_callback request.env["omniauth.auth"]
    data[:email].present? ? auth_with_email(data) : auth_without_email(data)
  end

  def auth_without_email data
    account = Account.find_by_uid_and_provider((data[:id] or data[:uid]), data[:provider])
    account.present? ? auth_user account.user : get_user_email data
  end

  def auth_with_email data
    user = Account.create_or_find_by_oauth_data data
    auth_user user
  end

  def auth_user user
    sign_in user
    redirect_to root_path, flash: { success: 'Successfully sign in' }
  end

  def get_user_email data
    session[:user_data] = data
    redirect_to enter_email_path, flash: { notice: 'To finish creation of account - need to enter email' }
  end


  def enter_email
    data =  session[:user_data]
    redirect_to root_path, flash: { error: "You try to access to admin page"} unless data
    email = params[:email]
    unless email.nil?
      temp = User.find_by_email(email)
      if temp.nil?
        data[:email] = email
        user = (Account.create_or_find_by_oauth_data data)
        session[:user_data] = nil
        auth_user user
      else
        redirect_to enter_email_path, flash: { error: "Already exist user with that email" }
      end
    end
  end



  def destroy_user_session
    sign_out current_user
    redirect_to root_path
  end

  [:facebook, :vkontakte, :google, :twitter].each { |provider| alias_method provider, :auth }

  private

  def get_data_from_callback raw_data
    provider = raw_data.provider.to_sym
    if provider == :google
      data     = raw_data.info
      data.uid = raw_data.uid.match(/id=(?<id>\w+)/)[:id]
      data.url = raw_data.extra.response.identity_url
      data.location = ""
    else
      data = raw_data.info.merge raw_data.extra.raw_info
      data.token = raw_data.credentials.token
      data.url = data.urls[provider.capitalize]
      data.photo = data.image
    end
    (data.photo = data.photo_big) if provider == :vkontakte
    if provider == :twitter
      data.secret =  raw_data.credentials.secret
      #data.url    =  data.urls[provider.capitalize]
    end
    #data.provider = provider
    #raise raw_data.to_yaml if raw_data.provider == :google
    #data.deep_symbolize_keys!
    #raise data.to_yaml
    #raise raw_data.to_yaml

    result = { provider: provider.to_s, email: data.email, first_name: data.first_name, last_name: data.last_name,
               patronymic: data.middle_name, phone: data.phone, address: (data.location['name'] or data.location),
               birthday: (data.birthday or data.bdate),  uid: (data.id or data.uid), secret: data.secret , token: data.token,
               language: (data.lang or data.locale), name: data.name, url: data.url, photo: data.photo, gender: (data.gender or data.sex)}#, login: data.nickname,
    #}
    #raise result.to_yaml
  end
end
