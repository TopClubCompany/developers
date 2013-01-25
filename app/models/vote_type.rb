class VoteType < ActiveRecord::Base
  attr_accessible :title, :description

  has_many :votes

  translates :title, :description

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds
end
# == Schema Information
#
# Table name: vote_types
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

