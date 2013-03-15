# -*- encoding : utf-8 -*-
class PositionType < Utils::Models::PositionType
  include EnumField::DefineEnum
  define_enum do |builder|
    builder.member :index, :object => new("index")
    builder.member :search, :object => new("search")
    builder.member :place, :object => new("place")
    builder.member :profile, :object => new("profile")
    builder.member :static_page, :object => new("static_page")
    builder.member :category, :object => new("category")
    builder.member :new_reservation, :object => new("new_reservation")
    builder.member :confirmed_reservation, :object => new("confirmed_reservation")
  end

end
