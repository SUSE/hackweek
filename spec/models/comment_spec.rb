require 'rails_helper'

describe Comment do
  it 'cleans up nested comments on deletion' do
    comment = create(:comment, :with_nested_comments)
    comment.destroy!
    expect(Comment.count).to eq 0
  end

  describe 'emoji support' do
    it 'saves and retrieves comments with emoji characters' do
      emoji_text = 'This is a great idea! 😱🎉👍'
      comment = create(:comment, text: emoji_text)
      comment.reload
      expect(comment.text).to eq(emoji_text)
    end
  end
end
