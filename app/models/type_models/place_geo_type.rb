class PlaceGeoType
  include EnumField::DefineEnum

  def initialize(code)
    @code = code.to_sym
  end

  define_enum do |builder|
    builder.member :close, :object => new("close")
    builder.member :walk, :object => new("walk")
    builder.member :drive, :object => new("drive")
    builder.member :far, :object => new("far")
  end

  def title
    I18n.t(@code, :scope => [:admin, :geo_type, :kind])
  end

  def code
    @code
  end

  def distance_label
    I18n.t(@code, :scope => [:admin, :geo_type, :distance])
  end

  def distance
     case @code.to_sym
       when :close
          0.5
       when :walk
          1
       when :drive
          5
       when :far
          10
       else
          100
     end
  end

end