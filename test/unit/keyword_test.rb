require 'test_helper'

class KeywordTest < ActiveSupport::TestCase

  test "create keyword" do
    keyword = Keyword.new :name => "rails"
    keyword.save!
    
    assert_equal "rails", keyword.name
  end

  test "project has interests" do
    project = projects(:one)
    keyword1 = keywords(:rails)
    keyword2 = keywords(:web)
    
    project.keywords << keyword1 << keyword2
    
    assert_equal project, keyword1.projects.last
    assert_equal project, keyword2.projects.last    
  end
  
  test "user has interests" do
    user = users(:one)
    
    keyword = keywords(:rails)
    
    user.keywords << keyword
    
    assert_equal user, keyword.users.last
  end
  
end
