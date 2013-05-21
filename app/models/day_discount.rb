class DayDiscount < ActiveRecord::Base
  attr_accessible :week_day_id, :from_time, :to_time, :discount, :title, :description, :is_discount

  belongs_to :week_day

  translates :title, :description

  include Utils::Models::Base
  include Utils::Models::Translations
  include TimeHelper

  scope :special, -> { where(is_discount: false) }

  scope :discount, -> { where(is_discount: true) }

  scope :with_day, lambda { |week_day_id, discount| where("is_discount = ? AND week_day_id = ?", discount, week_day_id) }

  def nice_offer_time
    [float_to_time_with_locale(from_time), float_to_time_with_locale(to_time)].join('-')
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
#  is_discount :boolean
#
# Indexes
#
#  index_day_discounts_on_week_day_id  (week_day_id)
#

