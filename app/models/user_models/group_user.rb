# -*- encoding : utf-8 -*-
class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
end
# == Schema Information
#
# Table name: group_users
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  user_id    :integer
#  is_chief   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_group_users_on_group_id  (group_id)
#  index_group_users_on_user_id   (user_id)
#

