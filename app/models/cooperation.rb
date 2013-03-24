class Cooperation < ActiveRecord::Base

  attr_accessible :email, :name, :phone, :place_name, :city

end
# == Schema Information
#
# Table name: cooperations
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  name       :string(255)
#  phone      :string(255)
#  place_name :string(255)
#  city       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

