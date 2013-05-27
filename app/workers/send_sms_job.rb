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
    
  end
end