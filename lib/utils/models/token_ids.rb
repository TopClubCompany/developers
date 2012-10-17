module Utils
  module Models
    module TokenIds
      def self.included(base)
        base.send :extend, SingletonMethods
      end

      module SingletonMethods
        def as_token_ids(*args)
          options = args.extract_options!

          class_attribute :as_token_ids_attrs, :instance_writer => false
          self.as_token_ids_attrs = args

          attr_accessible *args.map{|attr| ["token_#{attr}_ids", "#{attr}_ids"] }.flatten, options.slice(:as)

          args.each do |attr|
            define_method "token_#{attr}_ids=" do |val|
              assoc = attr.to_s.pluralize
              records = self.class.reflect_on_association(assoc.to_sym).klass.unscoped.where(:id => Utils.val_to_array(val)).uniq
              #records = self.class.reflect_on_association(assoc.to_sym).klass.unscoped.select(:id).where(:id => Utils.val_to_array(val)).uniq
              self.send("#{assoc}=", records)
            end

            define_method "token_#{attr}_ids" do
              self.send("#{attr}_ids")
            end
          end

          unless self.is_a?(ClassMethods)
            include InstanceMethods
            extend ClassMethods
          end
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        def token_single(assoc)
          rec = self.send(assoc)
          rec ? [rec.for_input_token] : []
        end

        def token_data(method, options={})
          assoc = self.class.reflect_on_association(method)
          records = self.send(method)
          data = Array(records).map(&:for_input_token)
          options.reverse_merge!(
              class: 'ac_token',
              data: {
                  pre: data.to_json,
                  class: assoc.klass.name,
                  limit: (1 unless assoc.collection?)
              })
        end
      end
    end
  end
end