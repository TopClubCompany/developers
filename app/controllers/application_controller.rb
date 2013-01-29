class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :current_city
  before_filter :set_time
  before_filter :set_user_location
  helper_method :current_city

  protected

    def current_city
      current_user.try(:city).try(:slug) || session['city'] || session[:city] || 'kyiv'
    end

    def set_locale
      if params[:locale] && Globalize.available_locales.include?(params[:locale].to_sym) && !request.xhr?
        I18n.locale = params[:locale].to_sym
      else
        I18n.locale = I18n.default_locale
      end
    end

  def set_user_location
    @user_location = cookies[:current_point].try(:split,',')
    if @user_location.present?
      @user_location.map(&:strip)
    else
      @user_location = ["50.451118","30.522301"]
    end
  end

  def set_time
    h,m = params[:reserve_time].try(:split,':')
    unless h and m
      h,m = (DateTime.now + (90 - DateTime.now.min % 15).minutes).strftime("%k:%M").split(':')
    end
    @time = {:h => h.to_s, :m => m.to_s }
  end
end
