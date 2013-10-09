require 'test_helper'

class ProjectSetupTest < ActionDispatch::IntegrationTest
  test "login, browse to linux and join" do
    user = users(:rms)
    project = projects(:linux)

    login_user user
    # Log in redirects to the users page
    assert page.find(".page-header").has_content?( user.name ), "User name '#{user.name}' not shown."

    # The project list should have this entry
    click_link("Projects")
    assert page.has_content?( "Linux" ), "Project overview is missing 'Linux'"

    # The project page for :linux should have this content
    click_link("Linux")
    assert page.has_content?( "assembler" ), "Project view not shown?"

    # Joining this project should flash an alert
    click_link "Join this project"
    assert page.find(".alert h3").has_content?( "Welcome to the project #{user.name}!" ), "Join alert not shown."

    logout_user
  end

end
