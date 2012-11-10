# -*- encoding : utf-8 -*-
module Utils
  module Maps
    class OpenStreetMap

      class << self
        @@url = 'http://nominatim.openstreetmap.org'

        def reverse_geocode options={}
          url = (options.delete(:url) || "#{@@url}/reverse")
          options[:format] ||= "json"
          languages = options.delete(:"accept-language")
          places = Hashie::Mash.new
          languages.each do |language|
            query_with_language = query(url, options.update(:"accept-language" => language))
            places[language.to_sym] = query_with_language
          end
          places
        end

        private
          def query url, options
            res = Curl.get(url, options)
            JSON.parse(res.body_str)
          end
      end
    end
  end
end