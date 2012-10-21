module Tire
  module Search
    class Query

      def flt(value, options={})
        @value = {:flt => {:like_text => value}}
        @value[:flt].update(options)
        @value
      end

    end
  end
end
