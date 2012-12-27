#encoding: utf-8

require 'soap/wsdlDriver'

module Utils
  module Soap
    module TurboSms
      class << self

        def send_sms(phone, text)
          return_value = {}
          get_client do |client|
            result = client.SendSMS(sender: Figaro.env.SMS_SENDER, destination: phone, text: text)
            begin
              result = result.sendSMSResult.try(:resultArray)
              return_value = {text: result[0], id: result[1]}
            rescue
              return_value = {}
            end
          end
          return_value
        end

        def get_client(&block)
          client = SOAP::WSDLDriverFactory.new('http://turbosms.in.ua/api/wsdl.html').create_rpc_driver
          client.Auth(login: Figaro.env.SMS_LOGIN, password: Figaro.env.SMS_PASSWORD)
          yield(client) if block_given?
        end

        def get_credit_balance(options = {})
          get_client do |client|
            client.getCreditBalance(options).getCreditBalanceResult
          end
        end

        def get_message_status(id)
          get_client do |client|
            client.getMessageStatus({MessageId: id}).getMessageStatusResult
          end
        end

      end

    end
  end
end