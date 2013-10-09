require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  test "log in and browse the page" do
    user = users(:linus)
    project = projects(:linux)

    # The front page should have content and a projects-link
    visit root_path
    assert page.has_content?( "Hack Week is the week where SUSE engineers can experiment without limits." ), "Front page not shown?"
    click_link ("list-link")

    # The project list should have these 3 entries
    assert page.has_content?( "Hurd" ), "Project overview is missing 'Hurd'"
    assert page.has_content?( "XNU" ), "Project overview is missing 'XNU'"
    assert page.has_content?( "Linux" ), "Project overview is missing 'Linux'"

    login_user user
    # Log in redirects to the users page
    assert page.find(".page-header").has_content?( user.name ), "User name '#{user.name}' not shown."

    # The project list should have these 3 entries
    click_link("List")
    assert page.has_content?( "Hurd" ), "Project overview is missing 'Hurd'"
    assert page.has_content?( "XNU" ), "Project overview is missing 'XNU'"
    assert page.has_content?( "Linux" ), "Project overview is missing 'Linux'"

    # The project page for project :hurd should have this content
    click_link("Hurd")
    assert page.has_content?( "Looking for mad skills in" ), "Project view not shown?"
    assert page.has_content?( "Hurd" ), "Project title 'Hurd' not shown."

    logout_user
  end

end
