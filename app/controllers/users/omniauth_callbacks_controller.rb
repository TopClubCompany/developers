class Users::OmniauthCallbacksController < ApplicationController
  def facebook
    user = Account.create_or_find_by_oauth_token request.env["omniauth.auth"]
    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in user
      redirect_to root_path
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end

  def vkontakte
  end


  def destroy_user_session
    sign_out current_user
    redirect_to root_path
  end
end
