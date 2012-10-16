require 'test_helper'

class SandboxControllerTest < ActionController::TestCase
  test "should get global" do
    get :global
    assert_response :success
  end

end
