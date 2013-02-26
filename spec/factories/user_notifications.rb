# == Schema Information
#
# Table name: user_notifications
#
#  id         :integer          not null, primary key
#  position   :integer          default(0)
#  is_visible :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_notification do
  end
end
