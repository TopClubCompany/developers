# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :destroy, :to => :delete
    @user = (user || User.new) # guest user (not logged in)

    admin
    #case @user.user_role_type.id
    #  when ::UserRoleType.default.id then default
    #  when ::UserRoleType.redactor.id then redactor
    #  when ::UserRoleType.moderator.id then moderator
    #  when ::UserRoleType.admin.id then admin
    #end
  end

  #def default
  #  can :manage, Comment, :user_id => @user.id
  #  can :create, Comment
  #end

  #def redactor
  #  can :manage, Comment, :user_id => @user.id
  #  can :create, Comment
  #end

  def moderator
    #can [:read, :create], AdminComment
    #can :destroy, AdminComment, :author_id => @user.id
    #can [:read, :create], Comment

    can [:read, :update], User, :id => @user.id
    # temp fix assets
    can :manage, Asset
    @rules += @user.fetch_rules
    cannot :destroy, User, :id => @user.id
  end

  def admin
    can :manage, :all
    can :manage, :all

    cannot :destroy, User, :id => @user.id
  end
end
