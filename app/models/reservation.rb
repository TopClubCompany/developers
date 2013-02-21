class Reservation < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone, :special_notes, :user_id, :time, :place_id, :persons

  belongs_to :user
  scope :old_reservations, lambda { |user_id| where("reservations.time<=? AND reservations.user_id=?","#{DateTime.now}", "#{user_id}") }
  scope :active_reservations, lambda { |user_id| where("reservations.time>=? AND reservations.user_id=?","#{DateTime.now}", "#{user_id}") }

  belongs_to :place

  validates_presence_of :email, :first_name, :last_name, :phone, :time, :persons

  def discount
    day = PlaceUtils::PlaceTime.wday(created_at.wday)
    discounts = place.week_days.includes(:day_discounts).where(:day_type_id => day).map(&:day_discounts).first
    discounts.find{|x| x.is_discount }.discount
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.create_from_place_and_user(current_user, place)
    if current_user
      new(first_name: current_user.first_name, last_name: current_user.last_name,
          phone: current_user.phone, user_id: current_user.id, place_id: place.id,
          email: current_user.email)
    end
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
#
# Indexes
#
#  index_reservations_on_place_id  (place_id)
#  index_reservations_on_user_id   (user_id)
#

