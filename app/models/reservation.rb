class Reservation < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone, :special_notes, :user_id, :time, :place_id,
                  :persons, :is_sms_send, :phone_code_id

  belongs_to :user
  scope :coming, lambda { |user_id| includes(:place).where("reservations.time<=? AND reservations.user_id=?","#{DateTime.now}", "#{user_id}") }
  scope :upcoming, lambda { |user_id| includes(:place).where("reservations.time>=? AND reservations.user_id=?","#{DateTime.now}", "#{user_id}") }

  belongs_to :place

  validates_presence_of :email, :first_name, :last_name, :phone, :time, :persons

  include Utils::Models::Base
  include Utils::Models::AdminAdds

  scope :with_time, lambda{|time| where("time <= ? AND is_sms_send = ?", time, false)}

  enumerated_attribute :phone_code, :id_attribute => :phone_code_id, :class => ::PhoneCodeType

  def discount
    day = PlaceUtils::PlaceTime.wday(created_at.wday)
    discounts = place.week_days.includes(:day_discounts).where(:day_type_id => day).map(&:day_discounts).first
    discounts.find{|x| x.is_discount }.try(:discount)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.create_from_place_and_user(current_user, place)
      new(first_name: current_user.try(:first_name), last_name: current_user.try(:last_name),
          phone: current_user.try(:phone), user_id: current_user.try(:id), place_id: place.id,
          email: current_user.try(:email))

  end


  def to_mail(opts={})
    discount = place.today_discount_with_time(time).select{|x| !x.respond_to?(:empty?)}.max{|x| x.discount}.try{|x| x.discount.try(:to_i)}
    skidka = discount.present? ? "Skidka #{discount}%" : ""
    {restaurant_name: place.title, restaurant_name_en: place.name_en,
     restaurant_id: place.id, reservation_id: id, skidka: skidka,
     number_of_people: persons, day_of_week: I18n.l(time, format: :day_name),
     mnth: I18n.l(time, format: :month), day: I18n.l(time, format: :day), year: I18n.l(time, format: :year),
     mnth_number: time.strftime("%m"), user_phone: phone, special_notes: special_notes,
     time: I18n.l(time, format: :hour_min), first_name: first_name, last_name: last_name,
     town: place.location.try(:city), restaurant_address: place.location.try(:address), restaurant_phone_number: place.phone,
     link_to_place: opts[:place_path], link_to_show_reservation: opts[:reservation_path],
     link_to_cancel_reservation: opts[:cancel_reservation_path], link_to_edit_reservation: opts[:edit_reservation_path]
    }
  end

  def self.available_time day, place
    week_day = place.week_days.where(:day_type_id => day).first
    time = Time.parse(week_day.start_at.to_f.to_s.sub(".",":"))
    time = Time.parse((time + (30 - time.min % 30).minutes).strftime("%k:%M"))
    times = []
    week_day.range_time.each do |time_item|
      times << ::PlaceUtils::PlaceTime.find_available_time(time_item * 30, time, week_day.range_time)
    end
    times.group_by{|time| time[:available]}[true].try{|available|available.map{|t|t[:time]}}
  end

  def meta_tag(city)
    {title: place.title, town: city
    }
  end

  def title
    id
  end


end
# == Schema Information
#
# Table name: reservations
#
#  id            :integer          not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  phone         :string(255)
#  email         :string(255)
#  special_notes :text
#  time          :datetime
#  user_id       :integer
#  place_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  persons       :integer
#  is_sms_send   :boolean          default(FALSE)
#
# Indexes
#
#  index_reservations_on_place_id  (place_id)
#  index_reservations_on_user_id   (user_id)
#

