# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  place_id   :integer
#  picture    :string(255)
#  title      :string(255)
#  body       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Note < ActiveRecord::Base
  belongs_to :place

end
