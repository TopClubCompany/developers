class PriceRange < ActiveRecord::Base

  attr_accessible :min_price, :max_price, :avg_price

  has_many :places, :dependent => :destroy

end
# == Schema Information
#
# Table name: price_ranges
#
#  id         :integer          not null, primary key
#  min_price  :float
#  max_price  :float
#  avg_price  :float
#  place_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

