# -*- encoding : utf-8 -*-
class Asset < ActiveRecord::Base
  self.include_root_in_json = true

  include Utils::Models::Asset

  attr_accessor :crop_attrs, :width, :height
  attr_accessible :data, :is_main
  attr_accessible :name_ru, :name_en, :name_it, :description_ru, :description_en, :description_it

  validates_presence_of :data

  has_many :asset_tags, :dependent => :destroy
  has_many :tags, :through => :asset_tags, :uniq => true

  #has_many :asset_p_colors, :dependent => :destroy
  #has_many :p_colors, :through => :asset_p_colors
  #has_many :color_textures, :through => :p_colors, :source => :texture

  has_many :asset_textures, :dependent => :destroy
  has_many :textures, :through => :asset_textures

  #default_scope includes(:translations)
  translates :name, :description
  attr_accessible *all_translated_attribute_names

  default_scope order("#{quoted_table_name}.sort_order")

  def add_color(params)
    color = asset_p_colors.new(params)
    color.save
    color.id
  end

  def remove_color(color_id)
    asset_p_colors.find(color_id).destroy
  end

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

# == Schema Information
#
# Table name: assets
#
#  id                :integer(4)      not null, primary key
#  data_file_name    :string(255)     not null
#  data_content_type :string(255)
#  data_file_size    :integer(4)
#  assetable_id      :integer(4)      not null
#  assetable_type    :string(25)      not null
#  type              :string(25)
#  guid              :string(10)
#  locale            :integer(1)      default(0)
#  user_id           :integer(4)
#  sort_order        :integer(4)      default(0)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  is_main           :boolean(1)      default(FALSE), not null
#

