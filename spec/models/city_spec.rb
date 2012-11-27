require 'spec_helper'

describe City do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  slug       :string(255)      not null
#  is_visible :boolean          default(TRUE)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_cities_on_slug  (slug) UNIQUE
#

