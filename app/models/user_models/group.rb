class Group < ActiveRecord::Base
  attr_accessible :group_type_id, :is_visible, :name, :description

  has_many :group_roles, :dependent => :destroy
  has_many :roles, :through => :group_roles

  has_many :group_users, :dependent => :destroy
  has_many :users, :through => :group_users

  has_many :group_chief_users, :conditions => {:is_chief => true}, :class_name => 'GroupUser', :dependent => :destroy
  has_many :chief_users, :through => :group_chief_users, :source => :user

  has_many :group_member_users, :conditions => {:is_chief => false}, :class_name => 'GroupUser', :dependent => :destroy
  has_many :member_users, :through => :group_member_users, :source => :user

  belongs_to :user

  enumerated_attribute :group_type, :id_attribute => :group_type_id, :class => ::GroupType
  translates :name, :description
  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  after_save proc { users.map(&:touch) }

  scope :admin, includes(:user, :roles)

  as_token_ids :user, :chief_user, :member_user, :role

  ac_field

end
#
# == Schema Information
#
# Table name: groups
#
#  id            :integer          not null, primary key
#  group_type_id :integer          default(1)
#  user_id       :integer
#  is_visible    :boolean          default(TRUE), not null
#  delta         :boolean          default(TRUE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_groups_on_user_id  (user_id)
#

