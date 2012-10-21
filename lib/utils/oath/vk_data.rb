# -*- encoding : utf-8 -*-
require 'net/http'
require 'net/https'
require 'uri'
module Utils
  module Oath
    module VkData
      VK_API_HOST = "api.vkontakte.ru"
      class << self
        def get_profile(uid)
          begin
#        fields = %w[sex bdate nickname country city contacts].join(',')
            query = uid.to_s.to_query('uids')+'&fields=sex,bdate,nickname,country,city,contacts'
            resp_data = JSON.parse(get_api_data("getProfiles", query))
            resp_data['response'].first
          rescue
            {}
          end
        end

        def get_cities(ids)
          begin
            resp_data = JSON.parse(get_api_data("getCities", ids.to_s.to_query('cids')))
            resp_data['response'].map { |c| c['name'] }
          rescue
            ''
          end
        end

        def get_countries(ids)
          begin
            resp_data = JSON.parse(get_api_data("getCountries", ids.to_s.to_query('cids')))
            resp_data['response'].map { |c| c['name'] }
          rescue
            ''
          end
        end

        private

        def get_api_data(method, params)
          path = "/method/#{method}"
          http = Net::HTTP.new(VK_API_HOST, 443)
          http.use_ssl = true
          r, data = http.post(path, params)
          data
        end
      end
    end
  end
end
