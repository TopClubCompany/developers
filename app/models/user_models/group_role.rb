# -*- encoding : utf-8 -*-
class GroupRole < ActiveRecord::Base
  belongs_to :group
  belongs_to :role
end
# == Schema Information
#
# Table name: group_roles
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_group_roles_on_group_id  (group_id)
#  index_group_roles_on_role_id   (role_id)
#

