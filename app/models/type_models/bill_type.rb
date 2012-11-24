class BillType
  include EnumField::DefineEnum

  def initialize(code)
    @code = code.to_sym
  end

  define_enum do |builder|
    builder.member :cheap, :object => new("cheap")
    builder.member :moderate, :object => new("moderate")
    builder.member :spendy, :object => new("spendy")
    builder.member :splurge, :object => new("splurge")
  end

  def title
    I18n.t(@code, :scope => [:admin, :bill, :kind])
  end

  def code_title
    I18n.t(@code, :scope => [:admin, :bill, :code])
  end

  def title_image
    I18n.t(@code, :scope => [:admin, :bill, :image])
  end

end