#coding: utf-8
module TimeHelper
  def float_to_time_with_locale float_number
    if I18n.locale.to_sym == :en
      Time.parse(("%5.2f" % float_number).sub(".",":")).strftime("%I:%M%p")
    else
      Time.parse(("%5.2f" % float_number).sub(".",":")).strftime("%H:%M")
    end
  end
end