require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get me" do
    get :me
    assert_response :success
  end

end
