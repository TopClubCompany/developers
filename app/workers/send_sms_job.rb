class SendSmsJob
  @queue = :low

  def self.perform
    time = DateTime.now - 12.hours
    Reservation.with_time(time).each do |reservation|
      reservation.is_sms_send = true
      self.send_sms(reservation)
      reservation.save()
    end
  end

  def self.send_sms(reservation)
    phone = reservation.phone.try { |ph| ph.gsub(/[\(\)-]/, '') }

    if !(phone =~ /\+/) && reservation.phone_code.present?
      phone = "#{reservation.phone_code.get_code}#{phone}"
    end

    text = I18n.t('sms_text', name: reservation.first_name, surname: reservation.last_name,
                  restaurant_name: reservation.place.name)
    Utils::Soap::TurboSms.send_sms(phone, text.no_html) if phone
  end
end