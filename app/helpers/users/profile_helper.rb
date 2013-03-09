module Users::ProfileHelper

  def user_menu_name user = current_user
    if user.first_name.present? && user.last_name.present?
      "#{user.first_name} #{user.last_name[0]}."
    else
      user.email
    end
  end

  def get_user_avatar user = current_user, avatar_size = :sidebar
    if user.try(:avatar).present? && user.avatar.url(avatar_size) !~ /(\/images\/defaults\/avatar_sidebar.png)/
       user.avatar.url(avatar_size)
    else
      if user.accounts.last
        user.accounts.last.photo
      else
        '/assets/no_avatar.gif'
      end
    end
  end

  def find_account_id(account)
    case account.provider
      when "twitter"
        "tw"
      when "facebook"
        "fb"
      when "google"
        "gp"
      when "vkontakte"
        "vk"
    end
  end

  def find_account_name(account)
    case account.provider
      when "twitter"
        "Twitter"
      when "facebook"
        "Facebook"
      when "google"
        "Google+"
      when "vkontakte"
        "VK.com"
    end
  end

  def to_time_format time
    if I18n.locale == :en
      time.strftime("%d/%m/%Y%l:%M %p")
    else
      time.strftime("%d/%m/%Y %H:%M")
    end
  end

  def time_hash(time)
    time = time.strftime("%I:%M %p").split(':')
    time[0][0]='' if time[0].match /^0/
    {:h => time[0], :m => time[1]}
  end

end
