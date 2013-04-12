require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest

  test "add keyword" do
    assume_user_logged_in users(:one)
    
    keyword = "rails"
    
    visit "/users/me/"
    assert_equal false, find(".keyword").has_content?( keyword ), "Keyword '#{keyword}' already there."
    
    fill_in :new_keyword, :with => keyword
    click_button "Add keyword"

    assert_equal "/users/me", current_path
    assert_equal true, find(".keyword").has_content?( keyword ), "Keyword '#{keyword}' missing."
  end

end
