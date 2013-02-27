class LetterType
  include EnumField::DefineEnum

  def initialize(code)
    @code = code.to_sym
  end

  define_enum do |builder|
    builder.member :successful_reserve_sms_user, :object => new("successful_reserve_sms_user")
    builder.member :successful_reserve_sms_place, :object => new("successful_reserve_sms_place")
    builder.member :successful_reserve_email_user, :object => new("successful_reserve_email_user")
    builder.member :successful_reserve_email_place, :object => new("successful_reserve_email_place")
    builder.member :cancel_reserve_email_user, :object => new("cancel_reserve_email_user")
    builder.member :cancel_reserve_email_place, :object => new("cancel_reserve_email_place")
    builder.member :edit_reserve_email_user, :object => new("edit_reserve_email_user")
    builder.member :new_reserve_email_top_club, :object => new("new_reserve_email_top_club")


  end

  attr_reader :code

  def title
    I18n.t(@code, :scope => [:admin, :letters])
  end
end