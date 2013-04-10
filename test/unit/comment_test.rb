require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "comment on project" do
    project = projects(:one)
    user = users(:one)
    
    text = "Cool stuff!"
    
    project.comments.create! :text => text, :commenter => user
    
    assert_equal 1, project.comments.count
    assert_equal text, project.comments.first.text
  end

  test "reply to comment" do
    project = projects(:one)
    user = users(:one)
    
    assert_difference "Comment.count", +2 do
      text1 = "Cool stuff!"
      comment = project.comments.create! :text => text1, :commenter => user

      text2 = "More cool stuff!"
      comment.comments.create! :text => text2, :commenter => user
      
      assert_equal 1, project.comments.count
      assert_equal 1, project.comments.last.comments.count
      assert_equal 0, project.comments.last.comments.last.comments.count
      assert_equal text2, project.comments.last.comments.last.text
    end
  end

  test "find parent" do
    project = projects(:one)
    user = users(:one)

    comment1 = project.comments.create! :text => "Comment One", :commenter => user
    assert_equal project, comment1.project

    comment2 = comment1.comments.create! :text => "Comment Two", :commenter => user
    assert_equal project, comment2.project
  end
  
end
