class DayDiscountSchedule < ActiveRecord::Base
  attr_accessible :place_id, :day_type_id, :is_running, :day_discounts_attributes

  has_many :day_discounts, :dependent => :destroy

  accepts_nested_attributes_for :day_discounts,
                                :allow_destroy => true, :reject_if => :all_blank

  enumerated_attribute :day_type, :id_attribute => :day_type_id, :class => ::DayType

  def self.create_for_new_place
    ::DayType.all.map do |day|
      self.new({day_type_id: day.id})
    end
  end

end
# == Schema Information
#
# Table name: day_discount_schedules
#
#  id          :integer          not null, primary key
#  place_id    :integer
#  day_type_id :integer
#  is_running  :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_day_discount_schedules_on_day_type_id  (day_type_id)
#  index_day_discount_schedules_on_place_id     (place_id)
#

