class MainSlider < ActiveRecord::Base
  attr_accessible :position

  has_one :slider, :as => :assetable, :dependent => :destroy

  fileuploads :slider

  include Utils::Models::Base
  include Utils::Models::AdminAdds

end
# == Schema Information
#
# Table name: main_sliders
#
#  id         :integer          not null, primary key
#  position   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

