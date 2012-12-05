class Users::ProfileController < ApplicationController
  before_filter :authenticate_user!

  def show

  end

  def invite_friends

  end
end
