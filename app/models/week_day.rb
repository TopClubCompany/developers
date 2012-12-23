class WeekDay < ActiveRecord::Base
  attr_accessible :title, :start_at, :end_at, :start_break_at, :end_break_at, :place_id,
                  :day_discounts_attributes, :day_type_id, :is_working

  belongs_to :place


  include Utils::Models::Base
  include Utils::Models::AdminAdds

  has_many :day_discounts, :dependent => :destroy

  accepts_nested_attributes_for :day_discounts,
                                :allow_destroy => true, :reject_if => :all_blank

  enumerated_attribute :day_type, :id_attribute => :day_type_id, :class => ::DayType

  def self.create_for_new_place
    ::DayType.all.map do |day|
      self.create({day_type_id: day.id})
    end
  end

end
# == Schema Information
#
# Table name: week_days
#
#  id             :integer          not null, primary key
#  start_at       :time
#  end_at         :time
#  start_break_at :time
#  end_break_at   :time
#  day_type_id    :integer          not null
#  is_working     :boolean          default(FALSE)
#  place_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_week_days_on_day_type_id  (day_type_id)
#  index_week_days_on_place_id     (place_id)
#

