# -*- encoding : utf-8 -*-
module Utils
  module Models
    module MissingAttributes

      def method_missing(sym, *args, &block)
        return self.send(sym.to_s.first(-6).concat('_type'), *args, &block).try(:title) if sym.to_s =~ /_title$/
        return self.send(sym.to_s.first(-5)) ? '+' : '-' if sym.to_s =~ /_bool$/
        return self.send(sym.to_s.first(-8)) if sym.to_s =~ /_no_html$/
        return self.pictures.map { |p| p.url($1) } if sym.to_s =~ /^pictures_(.*)$/
        return self.photo.try(:url, $1) if sym.to_s =~ /^photo_(.*)$/
        super(sym, *args, &block)
      end

    end
  end
end
