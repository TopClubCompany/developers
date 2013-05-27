class PhoneCodeType
  #must defining from cheapest to more expensive for place helper(get_pricing)
  include EnumField::DefineEnum

  def initialize(code)
    @code = code.to_sym
  end

  define_enum do |builder|
    builder.member :ukraine, :object => new("ukraine")
    builder.member :russia, :object => new("russia")
  end

  def title(locale=I18n.locale.to_sym)
    I18n.t(@code, :scope => [:admin, :phone_code, :kind], :locale => locale)
  end

  def get_code
    title.scan(/\+.*/).try(:first)
  end

end