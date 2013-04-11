require 'test_helper'

AccountController.send( :define_method, :auth_hash ) do
  {
    :uid => "fake:123",
    :info => { :name => "Hans Wurst", :email => "hw@example.com" }
  }
end

class LoginTest < ActionDispatch::IntegrationTest

  def login_with_google user
    assert find( ".container.content" ).find_link('Log in with Google')
    visit "/account/callback"
  end
  
  test "show public project page" do    
    project = projects(:one)
    
    visit project_path( project )
    assert page.has_content?( "Sign In" )
    assert find_link('Add a comment').visible?
  end

  test "commenting needs login" do
    project = projects(:one)
    
    visit project_path( project )
    click_link 'Add a comment'
    
    assert_equal "/account/login", current_path
  end
  
  test "add comment as not logged in user" do
    project = projects(:one)
    
    visit project_path( project )
    click_link 'Add a comment'
    login_with_google users(:one)
    assert_equal new_project_comment_path( project ), current_path
    fill_in :comment_text, :with => "My comment."
    click_button 'Add comment'
    assert_equal project_path( project ), current_path
    assert page.has_content?( "My comment." )    
    assert page.has_content?( "Hans Wurst" )
  end
  
end
