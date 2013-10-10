require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  test "create" do
    user = users(:linus)
    
    title= "Free Beer!"
    text = "Tomorrow..."

    announcement = Announcement.create(:title=> title, :text => text, :originator_id => user.id)

    assert_equal title, announcement.title
    assert_equal text, announcement.text
    assert_equal user, announcement.originator
  end

  test "user dismisses announcement" do
    user = users(:linus)
    announcement = announcements(:one)

    assert_equal 0, announcement.users.count

    announcement.enroll! user
    
    assert_equal 1, announcement.users.count
    assert_equal user, announcement.users.last
  end
end
