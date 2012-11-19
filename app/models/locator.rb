# -*- encoding : utf-8 -*-'
class Locator
  # attr_accessible :title, :body
  def self.find(*args)

  end

  def self.model_name
    Locator
  end

  def self.plural
    "locators"
  end

  def self.human(count)
    "Переводы"#I18n.t('admin.locator')
  end

  def title
    ''
  end
end

# == Schema Information
#
# Table name: locators
#
#  id :integer          not null, primary key
#

