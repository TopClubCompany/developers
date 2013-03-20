module ReservationsHelper
  def send_messages(reservation, types)
    options = {reservation_path: wrapp_domain(show_profile_reservation_path(current_user.id, reservation.id)),
               place_path: wrapp_domain(place_path(reservation.place_path)),
               edit_reservation_path: wrapp_domain(edit_profile_reservation_path(current_user.id, reservation.id)),
               cancel_reservation_path: wrapp_domain(cancel_profile_reservation_path(current_user.id, reservation.id))}
    phone = reservation.phone.try { |ph| ph.gsub(/[\(\)-]/, '') }
    types.each do |type|
      text, caption = ::Utils::LetterParser.parse_params(reservation.to_mail(options).merge({letter_type: type}))
      administrators = reservation.place.place_administrators
      case type
        when 1
          Utils::Soap::TurboSms.send_sms(phone, text.no_html) if phone
        when 2
          administrators.each do |admin|
            Utils::Soap::TurboSms.send_sms(admin.phone, text.no_html) if admin.phone
          end
        when 3
          AccountMailer.new_reservation(reservation.email, caption, text).deliver
        when 4
          send_message(administrators, caption, text)
        when 5
          AccountMailer.new_reservation(reservation.email, caption, text).deliver
        when 6
          send_message(administrators, caption, text)
        when 7
          AccountMailer.new_reservation(reservation.email, caption, text).deliver
        when 8
          AccountMailer.new_reservation("eugeniy.kriukov@topclub.kiev.ua", caption, text).deliver
      end
    end
  end

  def send_message(administrators, caption, text)
    administrators.each do |admin|
      AccountMailer.new_reservation(admin.email, caption, text).deliver if admin.email
    end
  end

  def wrapp_domain(url)
    "http://topreserve.com.ua/" + url
  end
end
