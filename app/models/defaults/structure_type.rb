# -*- encoding : utf-8 -*-
class StructureType < Utils::Models::StructureType
  include EnumField::DefineEnum
  define_enum do |builder|
    builder.member :static_page,     :object => new("static_page")
    builder.member :posts,    :object => new("posts")
    builder.member :main,     :object => new("main")
    builder.member :redirect, :object => new("redirect")
    builder.member :group,    :object => new("group")
    builder.member :catalogue,    :object => new("catalogue")
    builder.member :linked,    :object => new("linked")
    builder.member :events,    :object => new("events")
  end
end
