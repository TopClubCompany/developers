class DayDiscount < ActiveRecord::Base
  attr_accessible :week_day_id, :from_time, :to_time, :discount, :title, :description, :is_discount

  belongs_to :week_day

  translates :title, :description

  include Utils::Models::Base
  include Utils::Models::Translations

  scope :special, -> { where(is_discount: false) }

  scope :discount, -> { where(is_discount: true) }

  scope :with_day_and_time, lambda { |week_day_id, time| where("is_discount = ? AND week_day_id = ? AND from_time >= ? AND to_time <= ?", true, week_day_id, time, time) }

  def nice_offer_time
    [from_time, to_time].map{ |point| Time.strptime(point.to_s, "%H.%M").strftime("%I:%M%p") }.join('-')
  end

end
# == Schema Information
#
# Table name: day_discounts
#
#  id          :integer          not null, primary key
#  week_day_id :integer
#  from_time   :decimal(4, 2)
#  to_time     :decimal(4, 2)
#  discount    :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_day_discounts_on_week_day_id  (week_day_id)
#

