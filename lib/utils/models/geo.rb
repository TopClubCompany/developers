module Utils
  module Models
    module Geo
      extend ActiveSupport::Concern

      module ClassMethods
      end

      def lat_lon
        [lat, lon].join(',')
      end

    end
  end
end