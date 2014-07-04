#encoding: utf-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "add keywords" do
    user = users(:linus)
    
    user.add_keyword! "rails"
    user.add_keyword! "web"
    user.add_keyword! "web"
    user.add_keyword! "Rails"
    
    assert_equal ["angular.js", "rails", "web", "üöäß"], user.keywords.map { |k| k.name }.sort
  end

end
