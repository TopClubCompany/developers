# -*- encoding : utf-8 -*-
require "unicode_utils/downcase"

module Utils
  module I18none
    module Alphavit
      def self.init
       self.send(::I18n.locale)
      end
      def self.ru
        %w(А Б В Г Д Е Ж З И Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Э Ю Я)
      end

      def self.to_en(text)
        text = UnicodeUtils.downcase(text)

        ru_mapping = {"а" => "a", "б" => "b", "в" => "v", "г" => "g", "д" => "d", "е" => "e", "ё" => "e", "ж" => "j",
         "з" => "z", "и" => "i", "й" => "i", "к" => "k", "л" => "l", "м" => "m", "н" => "n",
         "о" => "o", "п" => "p", "р" => "r", "с" => "c", "т" => "t", "у" => "y", "ф" => "f",
         "х" => "x", "ц" => "c", "ч" => "ch", "ш" => "sh", "щ" => "sh", "ъ" => "", "ь" => "",
         "э" => "e", "ю" => "y", "я" => "i", "ы" => "u", " " => " "}
        rec_text = ""
        text.to_s.downcase.each_char do |char|
          if ru_char = ru_mapping[char].presence
            rec_text += ru_char
          else
            rec_text += char
          end
        end
        rec_text
      end
    end
  end
end