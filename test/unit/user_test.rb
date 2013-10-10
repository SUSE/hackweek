require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    Sunspot.commit
    User.reindex
  end

  test "add keywords" do
    user = users(:linus)
    
    user.add_keyword! "rails"
    user.add_keyword! "web"
    user.add_keyword! "web"
    user.add_keyword! "Rails"
    
    assert_equal ["angular.js", "rails", "web", "üöäß"], user.keywords.map { |k| k.name }.sort
  end

  test "user can be found by the exact name" do
    user = users(:linus)
    result = User.search { fulltext "linus" }
    assert_equal 1, result.results.length
    assert_equal [user], result.results
  end

  test "user can be found by name with different case (up/down)" do
    user = users(:linus)
    result = User.search { fulltext "lINus" }
    assert_equal 1, result.results.length
    assert_equal [user], result.results
  end

  test "user can be found by a substring of the name" do
    user = users(:linus)
    result = User.search { fulltext "linu" }
    assert_equal 1, result.results.length
    assert_equal [user], result.results
  end

  test "user can be found using operators" do
    user_l = users(:linus)
    user_j = users(:steve)
    result = User.search { fulltext "linus jobs" }
    assert_equal 0, result.results.length
    result = User.search { fulltext "linus -jobs" }
    assert_equal 1, result.results.length
    assert_equal [user_l], result.results
    result = User.search { fulltext "linus NOT jobs" }
    assert_equal 1, result.results.length
    assert_equal [user_l], result.results
  end
end
