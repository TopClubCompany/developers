class SendSmsJob
  @queue = :low

  def self.perform
    time = DateTime.now + 12.hourse
    Reservation.with_time(time).each do |reservation|
      reservation.is_sms_send = true
      self.send_sms(reservation)
      reservation.save()
    end
  end

  def self.send_sms(reservation)
    text = I18n.t('sms_text', name: reservation.first_name, surname: reservation.last_name,
                  restaurant_name: reservation.place.name)
    Utils::Soap::TurboSms.send_sms(reservation.phone, text.no_html) if reservation.phone
  end
end