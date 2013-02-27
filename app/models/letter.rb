class Letter < ActiveRecord::Base
  attr_accessible :topic, :content, :kind

  enumerated_attribute :letter_type, :id_attribute => :kind, :class => ::LetterType

  translates :topic, :content

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds
end
# == Schema Information
#
# Table name: letters
#
#  id         :integer          not null, primary key
#  kind       :integer          not null
#  is_visible :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

