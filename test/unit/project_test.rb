require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  test "create" do
    user = users(:one)
    
    title = "My Title"
    
    project = user.projects.create( :title => title )
    
    assert_equal title, project.title
    assert_equal user, project.originator
    
    assert_equal 1, project.updates.count
    assert_equal user, project.updates.last.author
    assert_match /originated/,project.updates.last.text
  end

end
