# -*- encoding : utf-8 -*-
module Utils
  module Models
    class StructureType
      def initialize(value)
        @kind = value
      end
      attr_reader :kind
      
      def title
        I18n.t(@kind, :scope => [:admin, :structure, :kind])
      end
    end
  end
end
