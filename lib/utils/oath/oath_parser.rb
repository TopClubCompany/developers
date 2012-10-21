# -*- encoding : utf-8 -*-
require 'net/http'
require 'net/https'
require 'uri'
module Utils
  module Oath
    class OathParser
      def initialize(raw_oath)
        @raw_oath = raw_oath
      end

      def parse
        raise "no data in oath #{@raw_oath.to_yaml}" unless @raw_oath['info']
        @res = {:provider => @raw_oath['provider'], :uid => @raw_oath['uid'],
                :name => @raw_oath['info']['name'], :nickname => @raw_oath['info']['nickname'],
                :last_name => @raw_oath['info']['last_name'], :first_name => @raw_oath['info']['first_name'],
                :email => @raw_oath['info']['email'], :photo => @raw_oath['info']['image']}
        if @raw_oath['credentials'].present?
          @res['token'] = @raw_oath['credentials']['token']
          @res['refresh_token'] = @raw_oath['credentials']['refresh_token']
          @res['secret'] = @raw_oath['credentials']['secret']
        end

        if @raw_oath.val('extra', 'raw_info')
          case @res[:provider]
            when 'vkontakte'
              vk
            when 'facebook'
              facebook
            when 'twitter'
              twitter
            when 'mailru'
              mailru
            else
              @res[:gender] = nil
          end
        end
        @res
      end

      def facebook
        @res[:gender] = case @raw_oath['extra']['raw_info']['gender']
                          when 'male'
                            1
                          when 'female'
                            2
                        end
        @res[:address] = @raw_oath['extra']['raw_info']['hometown']['name'] if @raw_oath['extra']['raw_info']['hometown']
        @res[:language] = @raw_oath['extra']['raw_info']['locale']
        @res[:url] = @raw_oath['info']['urls']['Facebook']
      end

      def twitter
        @res[:address] = @raw_oath['extra']['raw_info']['location']
        @res[:language] = @raw_oath['extra']['raw_info']['lang']
        @res[:url] = @raw_oath['info']['urls']['Twitter']
        if @res[:first_name].blank? && @res[:last_name].blank?
          o_names = @raw_oath['info']['name'].split(' ', 2)
          @res[:first_name], @res[:last_name] = o_names[0], o_names[1]
        end
      end

      def vk
        profile_data = ::Utils::Oath::VkData.get_profile(@res[:uid])
        address = []
        if profile_data['city'] && (city = ::Utils::Oath::VkData.get_cities(profile_data['city']).first)
          address << city
        end
        if profile_data['country'] && (country = ::Utils::Oath::VkData.get_countries(profile_data['country']).first)
          address << country
        end
        @res[:address] = address.join(' ')
        @res[:birthday] = @raw_oath['info']['birth_date']
        if @raw_oath['extra']['raw_info']['gender']
          @res[:gender] = case @raw_oath['extra']['raw_info']['gender']
                            when 2
                              1
                            when 1
                              2
                          end
        end
#        pars[:gender] = profile_data['sex'].to_i if profile_data['sex']
        phone = nil
        phone = profile_data['home_phone'] unless profile_data['home_phone'].blank?
        phone = profile_data['mobile_phone'] unless profile_data['mobile_phone'].blank?
        @res[:phone] = phone
        @res[:url] = @raw_oath['info']['urls']['Vkontakte']
      end

      def mailru
        @res[:url] = @raw_oath['info']['urls']['Mailru']
        @res[:gender] = case @raw_oath['extra']['raw_info']['sex']
                          when 0
                            1
                          when 1
                            2
                        end
        @res[:birthday] = @raw_oath['extra']['raw_info']['birthday']
      end
    end
  end

end
#--- !map:OmniAuth::AuthHash
#provider: facebook
#uid: "100002174624970"
#info: !map:OmniAuth::AuthHash::InfoHash
#  email: leschenko.al@gmail.com
#  name: Aleksandr Leschenko
#  first_name: Aleksandr
#  last_name: Leschenko
#  image: http://graph.facebook.com/100002174624970/picture?type=square
#  urls: !map:Hashie::Mash
#    Facebook: http://www.facebook.com/profile.php?id=100002174624970
#  location: Kyiv, Ukraine
#credentials: !map:Hashie::Mash
#  token: AAADqE0Wuey0BANDvxppbZA8VcWZAcFB1BoD3GynZBA50U3RS0EP7G7IhUvPSOi77KFV13bfKuhaSLZA647K0eh8FTOLttpfPoqkXri3sNwZDZD
#  expires_at: 1335617708
#  expires: true
#extra: !map:Hashie::Mash
#  raw_info: !map:Hashie::Mash
#    id: "100002174624970"
#    name: Aleksandr Leschenko
#    first_name: Aleksandr
#    last_name: Leschenko
#    link: http://www.facebook.com/profile.php?id=100002174624970
#    location: !map:Hashie::Mash
#      id: "111227078906045"
#      name: Kyiv, Ukraine
#    gender: male
#    email: leschenko.al@gmail.com
#    timezone: 2
#    locale: en_US
#    verified: true
#    updated_time: 2012-01-31T22:01:14+0000