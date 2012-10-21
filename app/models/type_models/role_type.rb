# -*- encoding : utf-8 -*-
class RoleType
  include EnumField::DefineEnum
  def initialize(code)
    @code = code.to_sym
  end

  attr_reader :code

  def title
    I18n.t(@code, :scope => [:admin, :role, :kind])
  end

  define_enum do |builder|
    builder.member :default,   :object => new("default")
    builder.member :group,  :object => new("group")
    builder.member :user, :object => new("user")
    builder.member :admin,     :object => new("admin")
  end

  def self.legal?(value)
    all.map(&:id).include?(value)
  end
end
