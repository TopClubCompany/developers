class ApplicationController < ActionController::Base
  protect_from_forgery
  include Styx::Initializer

  before_filter :set_locale
  before_filter :current_city

  protected

    def current_city
      session['city'] ||= (params[:city] || "Kyiv")
    end


    def set_locale
      if params[:locale] && Globalize.available_locales.include?(params[:locale].to_sym) && !request.xhr?
        I18n.locale = params[:locale].to_sym
      else
        I18n.locale = I18n.default_locale
      end
    end
end
