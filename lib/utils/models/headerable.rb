# -*- encoding : utf-8 -*-
module Utils
  module Models
    module Headerable
      extend ActiveSupport::Concern

      included do
        has_many :headers, :as => :headerable, :dependent => :destroy

        attr_accessible :headers_attributes

        accepts_nested_attributes_for :headers, :reject_if => :all_blank

        ::Header.all_translated_attribute_names.each do |attr|
          define_method "header_#{attr}=" do |val|
            default_header.send("#{attr}=", val)
          end

          define_method "header_#{attr}" do
            default_header.send(attr)
          end
        end
      end

      module ClassMethods
      end

      def default_header
        header || build_header
      end

    end
  end
end
