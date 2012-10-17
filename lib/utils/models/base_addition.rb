# -*- encoding : utf-8 -*-
module Utils
  module Models
    module BaseAddition
      def should_generate_new_friendly_id?
        new_record?
      end
    end
  end
end
