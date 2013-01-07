class Reservation < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone, :special_notes, :user_id, :time, :place_id, :persons

  belongs_to :user
  scope :old_reservations, lambda { |user_id| where("reservations.time<=? AND reservations.user_id=?","#{DateTime.now}", "#{user_id}") }
  scope :active_reservations, lambda { |user_id| where("reservations.time>=? AND reservations.user_id=?","#{DateTime.now}", "#{user_id}") }

  belongs_to :place

  validates_presence_of :email, :first_name, :last_name, :phone, :time, :persons

  def full_name
    "#{first_name} #{last_name}"#.strip
  end

  def self.create_from_place_and_user(current_user, place)
    self.new(first_name: current_user.try(:first_name), last_name: current_user.try(:last_name),
         phone: current_user.try(:phone), user_id: current_user.try(:id), place_id: place.try(:id),
         email: current_user.try(:email))
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

