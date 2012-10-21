# -*- encoding : utf-8 -*-
class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
              
  delegate :url, :current_path, :size, :content_type, :filename, :to => :data
  
  validates_presence_of :data
end

# == Schema Information
#
# Table name: ckeditor_assets
#
#  id                :integer(4)      not null, primary key
#  data_file_name    :string(255)     not null
#  data_content_type :string(255)
#  data_file_size    :integer(4)
#  assetable_id      :integer(4)
#  assetable_type    :string(30)
#  type              :string(30)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

