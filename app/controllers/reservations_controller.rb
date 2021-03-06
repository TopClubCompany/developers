class ReservationsController < ApplicationController

  before_filter :find_page, only: :show

  include ReservationsHelper

  def new_reservation
    @persons = params[:amount_of_person]
    @place   = Place.find(params[:place_id])
    time = params[:time].gsub(/[hm=]/,'').gsub('&',':')
    time = Place.en_to_time(time)
    @date = DateTime.parse("#{params[:date]} #{time}")
    @options = {:reserve_date => params[:date], :reserve_time => params[:time]}
    @special_offers = @place.today_discount_with_time(@date, false).select{|x| !x.respond_to?(:empty?)}
    @reservation = Reservation.create_from_place_and_user(current_user, @place)
    find_page(@reservation)
    redirect_to new_user_registration_path and return unless @reservation.present?
    @reservation.persons = @persons.to_i
  end

  def reservation_confirmed
    @reservation = Reservation.find(params[:reservation_id])
    find_page(@reservation, :confirmed_reservation)
    if current_user.try(:id) == @reservation.user_id || session[:reservation_user] == @reservation.user_id || session[:new_reservation_user] == @reservation.user_id
      @user = User.find(session[:new_reservation_user]) if !current_user && session[:new_reservation_user].present?
      @place = @reservation.try(:place)
      @date  = @reservation.time
      @discount = @place.today_discount_with_time(@date, false).select{|x| !x.respond_to?(:empty?)}.max{|x| x.discount}
      redirect_to root_path, flash: { error: I18n.t('reservation.no_such_reservation') } unless @reservation && @place
    else
      redirect_to root_path
    end
  end


  def complete_reservation
    reservation = Reservation.new(params[:reservation])
    unless current_user
      if user = User.find_by_email(reservation.email).presence
        reservation.user = user
        session[:reservation_user] = user.id
      else
        user = create_user_from_reservation(reservation)
        session[:new_reservation_user] = user.id
        reservation.user = user
      end
    end
    if reservation.save
      add_points(reservation)
      send_messages(reservation, [1,2,3,4,8]) if Rails.env.production?
      redirect_to reservation_confirmed_path(reservation.id)
    else
      redirect_to new_reservation_path(@reservation), flash: { error: @reservation.errors.full_messages.join(', ') }
    end
  end

  def available_time
    place = Place.find(params[:place_id])
    current_day = params[:reserve_date].present? ? DateTime.parse(params[:reserve_date]).wday : DateTime.now.wday
    current_day = PlaceUtils::PlaceTime.wday(current_day)
    respond_to do |format|
      format.json do
        render :json => {times: Reservation.available_time(current_day, place)}
      end
    end
  end

  def create_account
    @reservation = Reservation.find(params[:id])
    if params[:password] == params[:reenter_password] && params[:password].present?
      user = User.find(session[:new_reservation_user])
      session[:new_reservation_user] = nil
      user.password = params[:password]
      user.password_confirmation = params[:reenter_password]
      if user.save
        sign_in(user, by_pass: true)
        redirect_to profile_path(user)
      else
        redirect_to reservation_confirmed_path(@reservation.id), flash: { error: I18n.t('reservation.popup.errors_user_crate') }
      end
    else
      redirect_to reservation_confirmed_path(@reservation.id)
    end
  end

  def print
    @reservation = Reservation.find(params[:id])
    if current_user.try(:id) == @reservation.user_id || session[:reservation_user] == @reservation.user_id
      @place = @reservation.try(:place)
      @date  = @reservation.time
      @discount = @place.today_discount_with_time(@date, false).select{|x| !x.respond_to?(:empty?)}.max{|x| x.discount}
      redirect_to root_path, flash: { error: 'no such reservation' } unless @reservation && @place
      render "print", layout: "print"
    else
      redirect_to root_path
    end
  end

  private

  def add_points reservation
    user = reservation.user
    if user.reservations.size == 1
      user.points = user.points + 50
    else
      user.points = user.points + Figaro.env.POINTS.to_f
    end
    user.save
  end

  def find_page(reservation=nil, type=:new_reservation)
    if reservation
      structure = Structure.with_position(::PositionType.send(type)).first
      setting_meta_tags structure, reservation.meta_tag(City.find(current_city).name)
    end
  end

  def create_user_from_reservation reservation
    user_role_id  = UserRoleType.default.id
    password = Devise.friendly_token.first(6)
    user = User.new(first_name: reservation.first_name, last_name: reservation.last_name, password: password,
                    email: reservation.email, phone: reservation.phone)
    user.user_role_id = user_role_id
    user.activate.skip_confirmation!
    user.save
    user
  end

  private
  def set_breadcrumbs_front
    super
    @place   = Place.find(params[:place_id])
    @breadcrumbs_front << ["<a href=#{with_locale("search")}>#{I18n.t('breadcrumbs.search')}</a>&nbsp"]
    @breadcrumbs_front << ["<a href=#{@place.place_path}>#{@place.title}</a>&nbsp"]
    @breadcrumbs_front << ["<a href=#{request.path}>#{I18n.t('breadcrumbs.you_reserve')}</a>&nbsp"]
  end

end
