require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  test "should get show" do
    get :show, :id => users(:one).id
    assert_response :success
  end

  test "should get me" do
    login users(:one)
    
    get :me
    assert_response :success
  end

end
