class Users::ProfileController < ApplicationController
  before_filter :authenticate_user!

  def show
    current_user.full_name
  end
end
