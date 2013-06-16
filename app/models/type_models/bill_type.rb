class BillType
  #must defining from cheapest to more expensive for place helper(get_pricing)
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

  def title(scope, locale=I18n.locale.to_sym)
    I18n.t(@code, :scope => [:admin, :bill, scope, :kind], :locale => locale)
  end

  def code_title(scope, locale=I18n.locale.to_sym)
    I18n.t(@code, :scope => [:admin, :bill, scope, :code], :locale => locale)
  end

  def title_image(scope, locale=I18n.locale.to_sym)
    I18n.t(@code, :scope => [:admin, :bill, scope, :image], :locale => locale)
  end

end