class ApplicationController < ActionController::Base
  protect_from_forgery
  include Styx::Initializer

  before_filter :login_happy_user

  def login_happy_user
    sign_in User.find_by_first_name('Happy user') unless current_user
    @current_point ||= "50.4, 30.5"
  end

end
