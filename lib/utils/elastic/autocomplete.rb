module Utils
  module Elastic
    module Autocomplete
      def self.included(base)
        base.send :extend, SingletonMethods
      end

      module SingletonMethods
        def elasticsearch
          include Tire::Model::Search
          include Tire::Model::Callbacks
          index_prefix Utils.elastic_prefix
        end

        def ac_field(*args, &block)
          unless self.is_a?(ClassMethods)
            include InstanceMethods
            extend ClassMethods
          end

          options = args.extract_options!

          include Tire::Model::Search
          #include Utils::Elastic::Callbacks
          if options[:delay]
            unless options[:skip_after_save]
              after_save lambda { tire.update_index }
            end
            after_destroy lambda { tire.update_index }
          else
            include Tire::Model::Callbacks
          end
          index_prefix Utils.elastic_prefix

          class_attribute :ac_opts, :ac_attr, :instance_writer => false
          class_attribute :ac_search_attrs_cache
          self.ac_opts = options.reverse_merge(:localized => true)
          self.ac_attr = args.first || :name

          settings :analysis => {:analyzer => {:default => {:filter => 'lowercase', :tokenizer => 'keyword'}}}
        end
      end

      module ClassMethods
        def ac_search_attrs
          self.ac_search_attrs_cache ||= if ac_opts[:fields]
                                           ac_opts[:fields]
                                         else
                                           if ac_opts[:localized]
                                             I18n.available_locales.map { |l| "#{ac_attr}_#{l}" }
                                           else
                                             [ac_attr]
                                           end
                                         end
        end

        def token_search(query, options={})
          options.reverse_merge!({:per_page => 50, :fields => ac_search_attrs})
          q = options[:no_escape] ? query : query.lucene_escape
          return [] if query.blank?
          tire.search :per_page => options[:per_page] do
            query { string(q, :fields => options[:fields]) }
            sort { by options[:order], options[:sort_mode] || 'asc' } if options[:order].present?
            filter(:and, :filters => options[:with].map { |k, v| {:terms => {k => Utils.val_to_array(v)}} }) if options[:with].present?
            if options[:without].present?
              options[:without].each do |k, v|
                filter(:not, {:terms => {k => Utils.val_to_array(v)}})
              end
            end

            Rails.logger.debug { to_curl }
          end
        end

        def for_input_token(r, attr='name_ru')
          {:name => r[attr], :id => r.id}
        end
      end

      module InstanceMethods
        def to_indexed_json
          attrs = [:id, :created_at]
          Jbuilder.encode do |json|
            json.(self, *self.class.ac_search_attrs)
            json.(self, *attrs)
          end
        end
      end
    end
  end
end