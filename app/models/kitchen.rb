class Kitchen < ActiveRecord::Base
  #has_many :places

  has_many :place_kitchens, :dependent => :destroy
  has_many :places, :through => :place_kitchens


  attr_accessible :is_visible, :name, :description

  belongs_to :user

  has_many :pictures, :as => :assetable, :dependent => :destroy
  #has_one :image, :as => :assetable, :dependent => :destroy

  fileuploads :pictures

  translates :name, :description

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  ac_field

  def self.paginate(options = {})
    self.paginate(:page => options[:page], :per_page => options[:per_page]).to_a
  end

  def to_indexed_json
    attrs = [:id, :slug, :created_at, :for_input_token]
    Jbuilder.encode do |json|
      json.(self, *attrs)
      json.(self, *self.class.ac_search_attrs)
      json.parent_name parent.try(:name)
    end
  end



end
# == Schema Information
#
# Table name: kitchens
#
#  id         :integer          not null, primary key
#  slug       :string(255)      not null
#  user_id    :integer
#  is_visible :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_kitchens_on_slug     (slug) UNIQUE
#  index_kitchens_on_user_id  (user_id)
#

