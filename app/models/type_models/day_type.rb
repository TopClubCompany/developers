class DayType
  include EnumField::DefineEnum

  def initialize(code)
    @code = code.to_sym
  end

  define_enum do |builder|
    builder.member :monday, :object => new("monday")
    builder.member :tuesday, :object => new("tuesday")
    builder.member :wednesday, :object => new("wednesday")
    builder.member :thursday, :object => new("thursday")
    builder.member :friday, :object => new("friday")
    builder.member :saturday, :object => new("saturday")
    builder.member :sunday, :object => new("sunday")
  end

  def title
    I18n.t(@code, :scope => [:admin, :day_type])
  end
end