class MarkType < ActiveRecord::Base

  attr_accessible :name, :description, :included_in_overall, :is_noise

  scope :included, where(included_in_overall: true)

  translates :name, :description



  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds
end
# == Schema Information
#
# Table name: mark_types
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  included_in_overall :boolean          default(TRUE)
#  is_noise            :boolean          default(FALSE)
#

