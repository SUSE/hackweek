require 'test_helper'

class UpdateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "create" do
    user = users(:one)
    
    text = "New Stuff"
    
    project = projects(:one)
    update = project.updates.create(:text => text, :author => user)
    
    assert_equal text, update.text
    assert_equal project, update.project
    assert_equal user, update.author
  end
end
