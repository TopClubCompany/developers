require 'spec_helper.rb'
describe User do
  before(:all) do
    @user = FactoryGirl.create(:user)
  end
  it 'user have right full name' do
    @user.full_name.should eq "Bro Pro "
  end
  it 'activate user state method' do
    @user.activate
    @user.locked_at.should eq nil and @user.trusted?.should be_true
  end

  it 'need to have title' do
    @user.title.should eq ("Bro Pro" or "admin@adm.com")
  end
end