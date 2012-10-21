# -*- encoding : utf-8 -*-
class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end

# == Schema Information
#
# Table name: user_roles
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  role_id    :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

