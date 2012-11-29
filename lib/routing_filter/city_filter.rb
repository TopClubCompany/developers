module RoutingFilter
  class CityFilter < Filter

    class << self
      def cities
        @@cities ||= City.all.map { |city| city.slug.to_sym }
      end

      def cities=(locales)
        @@cities = cities.map(&:to_sym)
      end

      def cities_pattern
        @@cities_pattern ||= %r(^/(#{self.cities.map { |l| Regexp.escape(l.to_s) }.join('|')})(?=/|$))
      end
    end

    def around_recognize(path, env, &block)
      city = extract_segment!(self.class.cities_pattern, path)
      if city.present?
        params = {city: city, env: env}
        around_generate(params)
      else
        yield.tap do |params|
          {}
          # You can additionally modify the params here before they get passed
          # to the controller.
        end
      end

    end

    def around_generate(params, &block)
      city = params.delete(:city)
      env = params.delete(:env)
      if  valid_city?(city)
        if env.present?
          session = env['rack.session']
          session["city"] = city
          self.run(:around_recognize, "/", env) do
            params || {}
          end
        end
      else
        yield.tap do |result|
          url = "/"
          # You can change the generated url_or_path here. Make sure to use
          # one of the "in-place" modifying String methods though (like sub!
          # and friends).
        end
      end
    end

    protected

    private
    def valid_city? city
      if city
        @@cities.include?(city.to_sym)
      else
        false
      end
    end
  end
end