# -*- encoding : utf-8 -*-

module Utils
  module Models
    module Elastic
      extend ActiveSupport::Concern

      module ClassMethods
        def build_stops(str, options={})
          options.reverse_merge!({:analyzer => 'standard'})
          tokens = tire.index.analyze(str, options)
          tokens['tokens'].map_val('token')
        rescue
          []
        end
      end
    end
  end
end
