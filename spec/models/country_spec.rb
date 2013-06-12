require 'spec_helper'

describe Country do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  slug       :string(255)
#  is_visible :boolean          default(TRUE)
#  position   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_countries_on_slug  (slug) UNIQUE
#

