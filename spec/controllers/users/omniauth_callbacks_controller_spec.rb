require 'spec_helper'

describe Users::OmniauthCallbacksController do

  describe "GET 'facebook'" do
    it "returns http success" do
      get 'facebook'
      response.should be_success
    end
  end

  describe "GET 'vkontakte'" do
    it "returns http success" do
      get 'vkontakte'
      response.should be_success
    end
  end

end
