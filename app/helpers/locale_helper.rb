module LocaleHelper

  def locale_cap locale_object
    locale_object.mb_chars.capitalize.to_s
  end

  def locale_down locale_object
    locale_object.mb_chars.downcase.to_s
  end

end

