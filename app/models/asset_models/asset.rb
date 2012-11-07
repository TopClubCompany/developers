# == Schema Information
#
# Table name: assets
#
#  id                :integer          not null, primary key
#  data_file_name    :string(255)      not null
#  data_content_type :string(255)
#  data_file_size    :integer
#  assetable_id      :integer          not null
#  assetable_type    :string(25)       not null
#  type              :string(25)
#  guid              :string(10)
#  locale            :integer          default(0)
#  user_id           :integer
#  sort_order        :integer          default(0)
#  is_main           :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_assets_on_assetable_type_and_assetable_id           (assetable_type,assetable_id)
#  index_assets_on_assetable_type_and_type_and_assetable_id  (assetable_type,type,assetable_id)
#  index_assets_on_user_id                                   (user_id)
#

# -*- encoding : utf-8 -*-
class Asset < ActiveRecord::Base
  self.include_root_in_json = true

  include Utils::Models::Asset

  attr_accessor :crop_attrs, :width, :height
  attr_accessible :data, :is_main
  attr_accessible :name_ru, :name_en, :name_it, :description_ru, :description_en, :description_it

  validates_presence_of :data


  #default_scope includes(:translations)
  translates :name, :description
  attr_accessible *all_translated_attribute_names

  default_scope order("#{quoted_table_name}.sort_order")


  def self.thumb_size
    :thumb
  end

  def locales(local_attrs, param, opts={})
    attrs = {}
    ::I18n.available_locales.each do |locale|
      attrs.update("#{param}_#{locale}" => local_attrs["#{locale}"])
    end
    attrs.merge(opts)
  end

  def self.clean
    Asset.where(:created_at.lt => 1.day.ago).where('assetable_id IS NULL OR assetable_id = 0').destroy_all
  end
end
