module Users::ProfileHelper

  def user_menu_name
    if current_user.first_name.present? && current_user.last_name.present?
      "#{current_user.first_name} #{current_user.last_name[0]}."
    else
      current_user.email
    end
  end


end
