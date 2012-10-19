# == Schema Information
#
# Table name: kitchens
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Kitchen < ActiveRecord::Base
  has_many :places

end
