class Reservation < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone, :special_notes
end
# == Schema Information
#
# Table name: reservations
#
#  id            :integer          not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  phone         :string(255)
#  email         :string(255)
#  special_notes :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

