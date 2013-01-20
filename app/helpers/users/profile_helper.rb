module Users::ProfileHelper

  def user_menu_name
    if current_user.first_name.present? && current_user.last_name.present?
      "#{current_user.first_name} #{current_user.last_name[0]}."
    else
      current_user.email
    end
  end

  def get_user_avatar user = current_user, avatar_size = :sidebar
    user.try(:avatar) ? user.avatar.url(avatar_size) : '/assets/no_avatar.gif'
  end

end
