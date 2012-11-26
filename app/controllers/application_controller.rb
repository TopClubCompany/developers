class ApplicationController < ActionController::Base
  protect_from_forgery
  include Styx::Initializer

  before_filter :login_happy_user
  before_filter :set_locale
  before_filter :current_city

  protected

    def login_happy_user
      #sign_in User.last unless current_user
      @current_point ||= "50.4, 30.5"
    end

    def current_city
      session['city'] ||= (params[:city] || "Kiev")
    end


    def set_locale
      if params[:locale] && Globalize.available_locales.include?(params[:locale].to_sym) && !request.xhr?
        I18n.locale = params[:locale].to_sym
      else
        I18n.locale = I18n.default_locale
      end
    end
end
