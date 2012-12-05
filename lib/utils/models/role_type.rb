# -*- encoding : utf-8 -*-
module Utils
  module Models
    class RoleType
      def initialize(code)
        @code = code.to_sym
      end
      attr_reader :code

      def title
        I18n.t(@code, :scope => [:admin, :role, :kind])
      end

      def self.legal?(value)
        all.map(&:id).include?(value)
      end
    end
  end
end
