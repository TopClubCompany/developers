# -*- encoding : utf-8 -*-
module Utils
  module I18none
    module Alphavit
      def self.init
       self.send(::I18n.locale)
      end
      def self.ru
        %w(А Б В Г Д Е Ж З И Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Э Ю Я)
      end
    end
  end
end