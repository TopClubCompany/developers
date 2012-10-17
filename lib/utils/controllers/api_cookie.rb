# -*- encoding : utf-8 -*-
module Utils
  module Controllers
    module ApiCookie
      def api_cookie(value, key='as')
        data = api_verifier.generate(value)
        opts = {:value => data}
        opts[:domain] = configatron.domain.cookies unless configatron.domain.cookies =~ /localhost/
        cookies[key] = opts
      end

      def get_api_cookie(key='as')
        return nil unless cookies[key]
        api_verifier.verify(cookies[key]) rescue false
      end

      def api_verifier
        @api_verifier ||= ActiveSupport::MessageVerifier.new(configatron.api_abitant.cookie_key)
      end
    end
  end
end
