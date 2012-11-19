class Locator < ActiveRecord::Base
  # attr_accessible :title, :body
  def self.find(*args)
    first
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

