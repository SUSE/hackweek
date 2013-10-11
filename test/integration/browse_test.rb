require 'test_helper'

class BrowseTest < ActionDispatch::IntegrationTest
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

    # There shouldn't be an announcement
    assert page.has_no_selector?("#announcement-1"), "An announcement is shown but non one is logged in."

    login_user user

    # Log in redirects to the users page
    assert page.find(".page-header").has_content?( user.name ), "User name '#{user.name}' not shown."

    # After login there should be an announcement
    assert page.has_selector?("#announcement-1"), "No announcement is shown."

    # Announcements should go away if you dismiss them
    click_button("Got it!")
    assert page.has_no_selector?("#announcement-1"), "The announcement is still shown after dimissal."
    click_link("users_path")
    assert page.has_no_selector?("#announcement-1"), "The announcement popped up again after dimissal."

    # The project list should have these 3 entries
    click_link("projects_path")
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
