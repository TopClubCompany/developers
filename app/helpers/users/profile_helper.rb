module Users::ProfileHelper

  def user_menu_name user = current_user
    if user.first_name.present? && user.last_name.present?
      "#{user.first_name} #{user.last_name[0]}."
    else
      user.email
    end
  end

  def get_user_avatar user = current_user, avatar_size = :sidebar
    if user.try(:avatar)
       user.avatar.url(avatar_size)
    else
      if user.account.try(:photo)
        user.account.photo
      else
        '/assets/no_avatar.gif'
      end
    end
  end

end
