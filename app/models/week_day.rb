class WeekDay < ActiveRecord::Base
  attr_accessible :title, :start_at, :end_at, :start_break_at, :end_break_at, :place_id

  belongs_to :place

  translates :title

  include Tire::Model::Search
  include Tire::Model::Callbacks

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds
end
# == Schema Information
#
# Table name: week_days
#
#  id             :integer          not null, primary key
#  start_at       :float
#  end_at         :float
#  start_break_at :float
#  end_break_at   :float
#  place_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_week_days_on_place_id  (place_id)
#

