# -*- encoding : utf-8 -*-
module Utils
  module Models
    class PositionType
      def initialize(code)
        @code = code.to_sym
      end
      attr_reader :code
      
      def title
        I18n.t(@code, :scope => [:admin, :structure, :position])
      end  
    end
  end
end
