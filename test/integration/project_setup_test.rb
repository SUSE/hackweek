require 'test_helper'

class ProjectSetupTest < ActionDispatch::IntegrationTest
  test "login, browse to linux and join" do
    user = users(:rms)
    project = projects(:linux)

    login_user user

    # Navigate to the project
    click_link("projects_path")
    click_link("Linux")
    # Joining the project should flash an alert
    click_link "Join this project"
    assert page.find("#flash h3").has_content?( "Welcome to the project #{user.name}!" ), "Join alert not shown."

    logout_user
  end

end
