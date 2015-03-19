require 'rails_helper'

describe Comment do
  it "cleans up nested comments on deletion" do
    comment = create(:comment, :with_nested_comments)
    comment.destroy!
    expect(Comment.count).to eq 0
  end
end