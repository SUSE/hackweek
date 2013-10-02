require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "add keywords" do
    user = users(:one)
    
    user.add_keyword! "rails"
    user.add_keyword! "web"
    user.add_keyword! "web"
    user.add_keyword! "Rails"
    
    assert_equal ["css", "html", "javascript", "rails", "web"], user.keywords.map { |k| k.name }.sort
  end

end
