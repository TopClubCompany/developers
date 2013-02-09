# -*- encoding : utf-8 -*-
class Header < ActiveRecord::Base

  attr_accessible :tag_type_id, :content, :og_tag_attributes

  translates :content

  has_one :og_tag, :dependent => :destroy

  enumerated_attribute :tag_type, :id_attribute => :tag_type_id, :class => ::MetaTagType

  accepts_nested_attributes_for :og_tag,
                                :allow_destroy => true, :reject_if => :all_blank

  include Utils::Models::Base
  include Utils::Models::Header

end
# == Schema Information
#
# Table name: headers
#
#  id              :integer          not null, primary key
#  headerable_type :string(30)       not null
#  headerable_id   :integer          not null
#  tag_type_id     :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_headers_on_headerable_type_and_headerable_id  (headerable_type,headerable_id)
#  index_headers_on_tag_type_id                        (tag_type_id)
#

