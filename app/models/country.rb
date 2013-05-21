class Country < ActiveRecord::Base
  attr_accessible :title, :description, :is_visible, :position

  has_many :cities, :dependent => :destroy

  translates :title, :description

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds


end
# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  is_visible :boolean          default(TRUE)
#  position   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

