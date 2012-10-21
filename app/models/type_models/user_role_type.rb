# -*- encoding : utf-8 -*-
class UserRoleType < Utils::Models::RoleType
  include EnumField::DefineEnum

  define_enum do |builder|
    builder.member :default,   :object => new("default")
    builder.member :redactor,  :object => new("redactor")
    builder.member :moderator, :object => new("moderator")
    builder.member :admin,     :object => new("admin")
  end

  def title
    I18n.t(@code, :scope => [:admin, :user, :role])
  end
end
