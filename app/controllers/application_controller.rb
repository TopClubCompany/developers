class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :current_city
  before_filter :set_time

  protected

    def current_city
      session['city'] || session[:city] || current_user.try(:city).try(:slug) || 'kyiv'
    end

    def set_locale
      if params[:locale] && Globalize.available_locales.include?(params[:locale].to_sym) && !request.xhr?
        I18n.locale = params[:locale].to_sym
      else
        I18n.locale = I18n.default_locale
      end
    end

  def set_time
    @time = {:h => '10', :m => '30'}
  end
end
