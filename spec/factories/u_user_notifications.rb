# == Schema Information
#
# Table name: u_user_notifications
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  user_notification_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_u_user_notifications_on_user_notification_id_and_user_id  (user_notification_id,user_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :u_user_notification do
  end
end
