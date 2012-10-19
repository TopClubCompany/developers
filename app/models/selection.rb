# == Schema Information
#
# Table name: selections
#
#  id          :integer          not null, primary key
#  picture     :string(255)
#  user_id     :integer
#  kind        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Selection < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :places
end
