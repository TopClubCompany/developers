# -*- encoding : utf-8 -*-
class PositionType < Utils::Models::PositionType
  include EnumField::DefineEnum
  define_enum do |builder|
    builder.member :index, :object => new("index")
    builder.member :search, :object => new("search")
    builder.member :place, :object => new("place")
    builder.member :profile, :object => new("profile")
  end

end
