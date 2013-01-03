# -*- encoding : utf-8 -*-
class GenderType
  include EnumField::DefineEnum

  def initialize(code)
    @code = code.to_sym
  end

  define_enum do |builder|
    builder.member :male, :object => new("male")
    builder.member :female, :object => new("female")
    builder.member :else, :object => new("unknown")
  end

  attr_reader :code

  def title
    I18n.t(@code, :scope => [:admin, :gender])
  end
end
