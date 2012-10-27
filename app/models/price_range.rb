class PriceRange < ActiveRecord::Base

  attr_accessible :min_price, :max_price, :avg_price

  has_many :places, :dependent => :destroy

end
