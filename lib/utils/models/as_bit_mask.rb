module Utils
  module Models
    module AsBitMask
      def self.included(base)
        base.send :extend, SingletonMethods
      end

      module SingletonMethods
        def as_bit_mask(attr, options={})
          return 0 unless options[:source]

          options.reverse_merge!(:column => "#{attr}_mask")

          define_method "#{attr}=" do |val|
            source = self.send(options[:source])
            res = self.send("#{options[:column]}=", (val.map(&:to_sym) & source).map { |a| 2**source.index(a) }.sum)
            instance_variable_set("@#{attr}", res)
          end

          define_method attr do
            instance_variable_get("@#{attr}") || begin
              source = self.send(options[:source])
              res = source.reject { |r| ((self.send(options[:column]) || 0) & 2**source.index(r)).zero? }
              instance_variable_set("@#{attr}", res)
            end
          end
        end
      end

    end
  end
end