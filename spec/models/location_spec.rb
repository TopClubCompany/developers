# -*- encoding : utf-8 -*-'
require 'spec_helper'

describe Location do
  before (:each) do
    @location = FactoryGirl.create(:location)
  end

  context 'get all data from coordinates' do
    it 'should get all data' do
      @location.street.should eq "Саксаганского улица"
      @location.country.should eq "Украина"
      @location.county.should eq "Шевченковский район"
    end
  end
end
# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  locationable_id   :integer          not null
#  locationable_type :string(50)       not null
#  zip               :string(255)
#  latitude          :float
#  longitude         :float
#  distance          :float
#  house_number      :string(255)
#  country_code      :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_locations_on_locationable_id_and_locationable_type  (locationable_id,locationable_type)
#

