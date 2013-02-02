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
         {lte: "0.5km"}
       when :walk
         {lte: "1km"}
       when :drive
         {lte: "5km"}
       when :far
         {lte: "10km"}
       else
         {lte: "100km"}
     end
  end

end