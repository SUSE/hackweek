require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest

  def login_with_google user
    assert find( ".container.content" ).find_link('Log in with Google')
    Stubber.fake_authentication user
    visit "/account/callback"
    Stubber.unfake_authentication
  end
  
  test "show public project page" do    
    project = projects(:one)
    
    visit project_path( project )
    assert page.has_content?( "Sign In" )
    assert find_link('Add a comment').visible?
  end

  test "log in" do
    user = users(:one)

    visit "/account/login"
    login_with_google user
    
    assert page.find(".navbar").has_content?( user.name ), "User name '#{user.name}' not shown."
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
    assert find( ".container.content" ).find_link('Log in with Google')

    assume_user_logged_in users(:one)

    assert_equal new_project_comment_path( project ), current_path
    fill_in :comment_text, :with => "My comment."
    click_button 'Add comment'
    assert_equal project_path( project ), current_path
    assert page.has_content?( "My comment." )    
    assert page.has_content?( "Hans Eberhard Wurst" )
  end
  
  test "can't join projects when notlogged in" do
    project = projects(:one)
    
    visit project_path( project )
    assert_raise Capybara::ElementNotFound do
      find_button( "Join this project" )
    end

    visit "/account/login"
    assert find( ".container.content" ).find_link('Log in with Google')
    
    assume_user_logged_in users(:one)
    
    assert_equal project_path( project ), current_path
    assert find_button( "Join this project" ), "Join button should be there"
  end
  
end
