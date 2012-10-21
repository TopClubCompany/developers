# -*- encoding : utf-8 -*-
class StaticPageType
  include EnumField::DefineEnum
  def initialize(code)
    @code = code.to_sym
  end

  attr_reader :code

  def title
    I18n.t(@code, :scope => [:admin, :post, :kind])
  end

  define_enum do |builder|
    builder.member :default, :object => new("default")
    builder.member :pictures, :object => new("pictures")
    builder.member :video, :object => new("video")
  end
end
