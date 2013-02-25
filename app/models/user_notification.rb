class UserNotification < ActiveRecord::Base
  attr_accessible :is_visible, :title, :description, :position

  has_many :u_user_notifications, :dependent => :destroy

  has_many :users, :through => :u_user_notifications

  translates :title, :description

  scope :by_position, -> { order("position DESC") }


  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

end
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

