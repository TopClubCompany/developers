#encoding: utf-8

require 'soap/wsdlDriver'

module Utils
  module Soap
    module TurboSms
      class << self

        def send_sms(phone, text)
          auth_client.SendSMS(sender: "TopClub", destination: phone, text: text)
        end

        def client
          SOAP::WSDLDriverFactory.new('http://turbosms.in.ua/api/wsdl.html').create_rpc_driver
        end

        def auth_client
          client.Auth(login: Figaro.env.SMS_LOGIN, password: Figaro.env.SMS_PASSWORD)
        end

      end

    end
  end
end