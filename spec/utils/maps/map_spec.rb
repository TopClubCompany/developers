require 'spec_helper.rb'

describe Utils::Maps::OpenStreetMap do
  #before (:each) do
  #  @map = described_class.new
  #end



  it 'should return array hash' do
    described_class.reverse_geocode({:lat => 50.433277, :lon => 30.52167, :"accept-language" => %w(ru en)}).should be_a_kind_of(Hashie::Mash)
  end
end