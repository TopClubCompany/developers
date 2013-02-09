class MetaTagType
  include EnumField::DefineEnum

  def initialize(code)
    @code = code.to_sym
  end

  define_enum do |builder|
    builder.member :title, :object => new("title")
    builder.member :description, :object => new("description")
    builder.member :keywords, :object => new("keywords")
    builder.member :noindex, :object => new("noindex")
    builder.member :nofollow, :object => new("nofollow")
    builder.member :canonical, :object => new("canonical")
    builder.member :open_graph, :object => new("open_graph")
  end

  attr_reader :code

  def title
    I18n.t(@code, :scope => [:admin, :meta_tag])
  end
end