require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get show" do
    get :show, :id => users(:linus).id
    assert_response :success
  end

  test "should redirect me" do
    sign_in :user, User.find('1')
    
    get :me
    assert_redirected_to user_path(users(:linus))
  end

end
