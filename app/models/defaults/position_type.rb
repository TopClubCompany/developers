# -*- encoding : utf-8 -*-
class PositionType < Utils::Models::PositionType
  include EnumField::DefineEnum
  define_enum do |builder|
    builder.member :default, :object => new("default")
    builder.member :menu, :object => new("menu")
    builder.member :bottom, :object => new("bottom")
    builder.member :second_menu, :object => new("second_menu")
  end
end
