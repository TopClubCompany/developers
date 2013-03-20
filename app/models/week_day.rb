class WeekDay < ActiveRecord::Base
  attr_accessible :start_at, :end_at, :place_id,
                  :day_discounts_attributes, :day_type_id, :is_working

  belongs_to :place


  include Utils::Models::Base
  include Utils::Models::AdminAdds

  has_many :day_discounts, :dependent => :destroy

  scope :with_place_and_day, lambda { |place, day| where("day_type_id = ? AND place_id = ?", day, place) }

  accepts_nested_attributes_for :day_discounts,
                                :allow_destroy => true, :reject_if => :all_blank

  enumerated_attribute :day_type, :id_attribute => :day_type_id, :class => ::DayType


  def self.create_for_new_place
    ::DayType.all.map do |day|
      self.create({day_type_id: day.id})
    end
  end

  def day_type_title type = :full
    day_type.try(:title, type)
  end

  def range_time
    if !start_at.to_i.zero? || !end_at.to_i.zero?
      if start_at.to_i >= end_at.to_i
         (start_at.to_i..24).to_a + (0..(end_at.to_i - 1)).to_a.uniq
       else
         (start_at.to_i..(end_at.to_i - 1)).to_a.uniq
       end
    else
      []
    end
  end

end
# == Schema Information
#
# Table name: week_days
#
#  id          :integer          not null, primary key
#  start_at    :decimal(4, 2)
#  end_at      :decimal(4, 2)
#  day_type_id :integer          not null
#  is_working  :boolean          default(FALSE)
#  place_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_week_days_on_day_type_id  (day_type_id)
#  index_week_days_on_place_id     (place_id)
#

