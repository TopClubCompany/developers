# -*- encoding : utf-8 -*-
class GroupType
  include EnumField::DefineEnum
  def initialize(code)
    @code = code.to_sym
  end

  attr_reader :code

  def title
    I18n.t(@code, :scope => [:admin, :group, :kind])
  end

  define_enum do |builder|
    builder.member :default,   :object => new("default")
    builder.member :public,  :object => new("public")
    builder.member :private, :object => new("private")
    builder.member :admin,     :object => new("admin")
  end

  def self.legal?(value)
    all.map(&:id).include?(value)
  end
end
