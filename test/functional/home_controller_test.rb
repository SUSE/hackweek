require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  def setup
    login users(:one)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

end
