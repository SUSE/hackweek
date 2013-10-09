require 'test_helper'

class UserSetupTest < ActionDispatch::IntegrationTest
  test "login and edit keywords" do
    user = users(:linus)

    login_user user
    # Log in redirects to the users page
    assert_equal current_path, user_path(user), "Path isn't #{user_path(user)} but #{current_path}"
    assert page.find(".page-header").has_content?( user.name ), "User name '#{user.name}' not shown."
    assert page.find(".page-header").has_content?( user.email ), "User email '#{user.email}' not shown."

    # Worked on projects
    assert_equal page.all('table.table tr').length, 1, "Linus works only on linux"
    assert page.find(".table").has_link?( "Linux" ), 'Worked on project "Linux" not shown.'

    # Originated projects
    click_link("Originated")
    assert_equal page.all('table.table tr').length, 2, "Linus originated linux and git"
    assert page.find(".table").has_link?( "Linux" ), 'Originated project "Linux" not shown.'
    assert page.find(".table").has_link?( "git" ), 'Originated project "git" not shown.'

    # Liked projects
    click_link("Likes")
    assert_equal page.all('table.table tr').length, 1, "Linus likes only Debian"
    assert page.find(".table").has_link?( "Debian" ), 'Liked project "Debian" not shown.'

    # Recommended projects
    click_link("Opportunities")
    assert_equal page.all('table.table tr').length, 1, "Linus could only work on openSUSE"
    assert page.find(".table").has_link?( "openSUSE" ), 'Opportunity "openSUSE" not shown.'

    # Keywords
    assert_equal page.all('#keywords .keyword').length, 2, 'Linus is looking for "üöäß" and "angular.js"'
    assert page.find("#keywords").has_link?('remove-6'), 'User keyword "üöäß" not shown'
    assert page.find("#keywords").has_link?("remove-5"), 'User keyword "angular.js" not shown.'

    # Add keyword
    find(:xpath, "//div[contains(@class,'selectize-input')]/input").set "foss,"
    click_button 'Save Keywords'
    assert_equal page.all('#keywords .keyword').length, 3, 'Linus is looking for "üöäß", "angular.js" and "foss"'
    assert page.find("#keywords").has_link?('remove-6'), 'User keyword "üöäß" not shown'
    assert page.find("#keywords").has_link?("remove-5"), 'User keyword "angular.js" not shown.'
    assert page.find("#keywords").has_link?("remove-7"), 'User keyword "foss" not shown.'

    # With the keyword foss we should have one more opportunity
    click_link("Opportunities")
    assert_equal page.all('table.table tr').length, 2, "Linus could only work on openSUSE and Windows"
    assert page.find(".table").has_link?( "openSUSE" ), 'Opportunity "openSUSE" not shown.'
    assert page.find(".table").has_link?( "Windows" ), 'Opportunity "Windows" not shown.'

    # Remove keyword

    logout_user
  end

end
