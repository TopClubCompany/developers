#encoding: utf-8
class LetterSeed
    class << self
      def insert_letters
        Letter.full_truncate
        user_sms = """
          Vash stol v {restaurant_name} zabronirovan!
          № broni: # {restaurant_id}-{reservation_id}
          DAY-MNTH-YEAR, 00:00
          Skidka {percent_number}%
          TopReserve, (044) 300-00-10
        """

        Letter.create do |l|
          l.content_ru = user_sms
          l.content_en = user_sms
          l.content_ua = user_sms
          l.kind = 1
        end.save!

        restoran_sms = """
          Zakaz stolika {restaurant_name}:
          {time}
          {Name} {Surname}
          {user_phone_number}
          TopReserve booking
        """
        Letter.create do |l|
          l.content_ru = restoran_sms
          l.content_en = restoran_sms
          l.content_ua = restoran_sms
          l.kind = 2
        end.save!

        user_email_en = """
        Dear {Name} {Surname},

        Your reservation for {number_of_people} at {restaurant_name} is confirmed for {day_of_week}, {Mnth} {Date}, {Year} at {Time}. The reservation is held under: {Name} {Surname}. Be sure to check in with the maitre d' when you arrive.

        From the restaurant:
        Thank you for choosing {restaurant_name}. We are pleased to confirm your dining reservation made through TopReserve.com.ua. If you have a change of plans and need to cancel or reschedule, please let us know. We look forward to welcoming you!

        To get there:
        {restaurant_name} - {town}
        {restaurant_address}
        {restaurant_phone_number}

        See menus, map & more > {link_to_place}

        Update your reservation date, time or party size > {link_to_show_reservation}

        Cancel your reservation > {link_to_cancel_reservation}

        Please keep this email for your records. Your confirmation number: # {restaurant_id}-{reservation_id}

        ** Questions about your reservation? You can always contact {restaurant_name} - {town} at {restaurant_phone_number} with any questions.

        --
        As always, thanks for using TopReserve.

        Happy Dining!

        TopReserve Restaurant reservations
        www.TopReserve.com.ua
      """

        user_email_ru = """

        Уважаемый(я) {Name} {Surname},

        Ваш резерв на {number_of_people} человек на {day_of_week}, {Mnth} {Date}, {Year} at {Time} в {restaurant_name} подтвержден. Стол забронирован на имя {Name} {Surname}. Не забудьте сообщить свое имя администратору заведения по приезду. Для получения специальных предложений, которые Вам полагаются как пользователю TopReserve (скидки и т.п.) напомните, что Вы резервировали стол через сервис TopReserve.

        От ресторана:
        Спасибо что выбрали {restaurant_name}. Мы рады сообщить Вам о том, что Ваш резерв через сервис TopReserve.com.ua подтвержден. Если ваши планы поменяются и вы решите изменить время или отменить бронь, пожалуйста предупредите нас об этом. Ждем вас!

        Как добраться:
        {restaurant_name} - {town}
        {restaurant_address}
        {restaurant_phone_number}

        Посмотреть меню, карту проезда и отзывы > - {link_to_place}

        Изменить дату, время и кол-во человек > - {link_to_edit_reservation}

        Отменить ваш резерв > - {link_to_cancel_reservation}

        Пожалуйста сохраните это письмо.
        Ваш код подтверждения брони: # {restaurant_id}-{reservation_id}

        ** Возникли вопросы по поводу вашей брони? Вы всегда можете связаться с {restaurant_name} - {town} по номеру {restaurant_phone_number}. Также звоните на нашу горячую линию: (044) 300-00-10

        --
        Спасибо, что воспользовались сервисом TopReserve.
        Приятного вечера!
        TopReserve Restaurant reservations
        www.TopReserve.com.ua

      """
        Letter.create do |l|
          l.topic_en = "Your Reservation Confirmation for {restaurant_name}"
          l.topic_ru = "Подтверждение резерва в {restaurant_name}"
          l.topic_ua = "Підтвердження резерву в {restaurant_name}"
          l.content_ru = user_email_ru
          l.content_en = user_email_en
          l.content_ua = user_email_ru
          l.kind = 3
        end.save!

      restoran_email_ru = """
      Уважаемый {restaurant_name},

      В ваш ресторан поступил новый резерв столика:

	      Заказ столика {restaurant_name}:
	      {time}
	      {Name} {Surname}
	      {user_phone_number}

	      Несколько слов от TopReserve:
          Уважаемый ресторан-партнер, не забывайте уведомить клиента в случае полной посадки вашего заведения, а также подтвердить доступность столика с помощью телефонного звонка. Также звоните на нашу горячую линию: (044) 300-00-10

        --
          As always, thanks for beeing a part of TopReserve reservation service.

        TopReserve Restaurant reservations
        www.TopReserve.com.ua
       """
        Letter.create do |l|
          l.topic_en = "New Reservation for {restaurant_name}"
          l.topic_ru =  "Новый резерв столика в {restaurant_name}"
          l.content_ru = restoran_email_ru
          l.content_en = restoran_email_ru
          l.content_ua = restoran_email_ru
          l.kind = 4
        end.save!

      cancel_user_email_en = """
        ENG: Dear {Name} {Surname},

        You've successfully canceled your reservation for a party of {number_of_people} at {restaurant_name} on {day_of_week}, {Mnth} {Date}, {Year} at {Time}.

        For your reference, here is the confirmation number of the original reservation: # {restaurant_id}-{reservation_id}

        Thank you for taking the time to cancel and making this table available to other diners.

        We hope to see you on TopReserve again soon!

        The TopReserve Team
        www.TopReserve.com.ua

        PS. Making or changing reservations on the go is a snap with TopReserve Mobile.

        ** Questions about your reservation? You can always contact {restaurant_name} - {town} at {restaurant_phone_number} with any questions.

        Got a question for TopReserve? Visit TopReserve FAQ section to get answers!

        PLANNING A PARTY? With the new TopReserve Private Dining pages, you can see photos and descriptions of hundreds of restaurants and find the ideal spot for your event. Try it now!
      """
        cancel_user_email_ru = """
           Уважаемый(я), {Name} {Surname},

          Вы успешно отменили резерв стола на {number_of_people} человек в {restaurant_name} на {Time} {day_of_week}, {Mnth} {Date}, {Year}.

          Спасибо, что нашли время, чтобы отменить заказ и сделать этот стол свободным для других посетителей.

          Мы надеемся скоро снова видеть Вас на TopReserve!

          --
          Команда TopReserve
          www.TopReserve.com.ua

          ** Возникли вопросы по Вашему резерву? Вы всегда можете связаться с {restaurant_name} по номеру {restaurant_phone_number}. Также звоните на нашу горячую линию: (044) 300-00-10

          Возникли вопросы по работе TopReserve? Посетите раздел часто задаваемых вопросов (FAQ) на TopReserve.

          Планируете вечеринку, корпоратив, свадьбу? С новым сервисом Private Dining от TopReserve Вы сможете увидеть фотографии и описан
                """
        cancel_user_email_ua = """
          Вельмишановний(а) {Name} {Surname}
          Ви успішно скасували резерв столу на {number_of_people} людей в {restaurant_name} на {Time} {day_of_week}, {Mnth} {Date}, {Year}.

          Дякуємо, що знайшли час, щоб скасувати замовлення і зробити цей стіл вільним для інших відвідувачів.

          Ми сподіваємося скоро знову бачити Вас на TopReserve!

          Команда TopReserve
          www.TopReserve.com.ua

          ** Виникли питання щодо Вашого резерву? Ви завжди можете зв'язатися з {restaurant_name} за номером {restaurant_phone_number}. Також звертайтеся до нашої службі пидтримки: (044) 300-00-10

          Виникли питання по роботі TopReserve? Відвідайте розділ поширених питань (FAQ) на TopReserve.

          Плануєте вечірку, корпоратив, весілля? З новим сервісом Private Dining від TopReserve Ви зможете побачити фотографії і опис сотень ресторанів і знайти ідеальне місце для вашого заходу. Спробуйте зараз!
        """
        Letter.create do |l|
          l.topic_en = "Your {restaurant_name} Reservation Cancellation"
          l.topic_ru =  "Your {restaurant_name} Reservation Cancellation"
          l.topic_ua =  "Your {restaurant_name} Reservation Cancellation"
          l.content_ru = cancel_user_email_ru
          l.content_en = cancel_user_email_en
          l.content_ua = cancel_user_email_ua
          l.kind = 5
        end.save!


        Letter.create do |l|
          l.topic_en = "Reservation Cancellation"
          l.topic_ru =  "Reservation Cancellation"
          l.topic_ua =  "Reservation Cancellation"
          l.content_ru = ""
          l.content_en = ""
          l.content_ua = ""
          l.kind = 6
        end.save!

        user_email_en = """
          Dear {Name} {Surname},

            You've successfully changed your reservation. {restaurant_name} will be ready for your party of {number_of_people} at {Time} on {day_of_week}, {Mnth} {Date}, {Year}. Confirmation Number: # {restaurant_id}-{reservation_id}

          Be sure to check in with the maitre d' when you arrive.

            From the restaurant:
          Thank you for choosing {restaurant_name}. We are pleased to confirm your dining reservation made through TopReserve.com.ua. If you have a change of plans and need to cancel or reschedule, please let us know. We look forward to welcoming you!

          To get there:
          {restaurant_name} - {town}
          {restaurant_address}
          {restaurant_phone_number}

        See menus, map & more > {link_to_place}

        Update your reservation date, time or party size > {link_to_show_reservation}

        Cancel your reservation > {link_to_cancel_reservation}

          ** Questions about your reservation? You can always contact {restaurant_name} - {town} at (000) 111-11-11 with any questions.

          --
          As always, thanks for using TopReserve.

          Happy Dining!

          TopReserve Restaurant reservations
          www.TopReserve.com.ua

      """

        user_email_ru = """
           Уважаемый(я), {Name} {Surname},
          	Вы успешно изменили бронирование. {restaurant_name} ресторан будет готов к приходу Вас и Ваших гостей в количестве {number_of_people} человек, в {Time}, в {day_of_week}, {Mnth} {Date}, {Year}.

          Номер подтверждения: # {restaurant_id}-{reservation_id}
          Не забудьте сообщить свое имя администратору заведения по приезду. Для получения специальных предложений, которые Вам полагаются как пользователю TopReserve (скидки и т.п.) напомните, что Вы резервировали стол через сервис TopReserve.

          От ресторана:
          Спасибо, что выбрали  {restaurant_name}. Мы с радостью подтверждаем Ваш резерв, сделанный через сервис TopReserve.com.ua. Если у Вас изменяться планы и нужно будет отменить резерв, пожалуйста, известите нас об этом. С нетерпением ждем Вас!

          Как добраться:
          {restaurant_name} - {town}
          {restaurant_address}
          {restaurant_phone_number}

          Посмотреть меню, карту и больше информации > {link_to_place}

          Обновить дату резерва, время или количество гостей >   {link_to_show_reservation}

          Отменить резерв > {link_to_cancel_reservation}

          ** Возникли вопросы относительно Вашего резерва? Вы всегда можете обратиться в {restaurant_name} - {town} по тел. {restaurant_phone_number} с любыми вопросами. Также звоните на нашу горячую линию: (044) 300-00-10

          --
          Спасибо, что воспользовались сервисом TopReserve.
          Приятного вечера!
          TopReserve Restaurant reservations
          www.TopReserve.com.ua
        """

        user_email_ua = """
        Шановний (на), {Name} {Surname},
        Ви успішно змінили параметри резерву. {restaurant_name} ресторан готовий буде прийняти Вас та Ваших гостей в кількості {number_of_people} осіб, в {Time}, в {day_of_week}, {Mnth} {Date}, {Year}.
        Номер підтвердження: # {restaurant_id}-{reservation_id}
        Перевірте інформацію у адміністратора, коли прибудете на місце. Для отримання знижок та акцій, на які ви маєте право як користувач TopReserve, нагадайте, що Ви резервували стіл через сервіс TopReserve.

        Від ресторану:
        Дякуємо, що вибрали {restaurant_name}. Ми з радістю підтверджуємо Ваш резерв, зроблений за допомогою сервісу TopReserve.com.ua. Якщо у Вас зміняться плани і потрібно буде відмінити резерв, будь ласка, повідомте нас про це. З нетерпіння чекаємо на зустріч з Вами!

        Контакти:
        {restaurant_name} - {town}
        {restaurant_address}
        {restaurant_phone_number}

        Подивитися меню, карту і більше інформації > {link_to_place}

        Оновити дату резерву, час і кількість гостей > {link_to_show_reservation}

        Відмінити резерв > {link_to_cancel_reservation}

        ** Виникли питання відносно Вашого резерву? Ви завжди можете звернутися до {restaurant_name} - {town} за тел. {restaurant_phone_number} з будь-якими питаннями. Також звертайтеся до нашої службі пидтримки: (044) 300-00-10

        --
        Дякуємо, що скористалися сервісом TopReserve.
        Приємного вечору!
        TopReserve Restaurant reservations
        www.TopReserve.com.ua
        """


        Letter.create do |l|
          l.topic_en = "Your {restaurant_name} Reservation Change"
          l.topic_ru =  "Your {restaurant_name} Reservation Change"
          l.topic_ua =  "Your {restaurant_name} Reservation Change"
          l.content_ru = user_email_ru
          l.content_en = user_email_en
          l.content_ua = user_email_ua
          l.kind = 7
        end.save!


      top_email = """
        Заказ столика {restaurant_name}:
	      {time}
	      {Name} {Surname}
	      {user_phone_number}
      """
        Letter.create do |l|
          l.topic_en = "Новый резерв столика в {restaurant_name}"
          l.topic_ru =  "Новый резерв столика в {restaurant_name}"
          l.topic_ua =  "Новый резерв столика в {restaurant_name}"
          l.content_ru = top_email
          l.content_en = top_email
          l.content_ua = top_email
          l.kind = 8
        end.save!

    end
  end
end