require 'test_helper'

class ExplorerControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
