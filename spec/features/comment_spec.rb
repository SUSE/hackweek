require 'rails_helper'

feature 'Comment' do
  let(:user) { create :user }
  let(:project) { create(:idea, originator: user) }
  let(:project_with_comments) { create(:idea, :with_comments, originator: user) }
  let(:comment_text) { Faker::Lorem.sentence }

  before :each do
    sign_in user
  end

  scenario 'markdown preview', :js do
    visit project_path(:all, project)
    fill_in 'comment_text', with: '_italic_ **bold** :smile: @user'
    click_on 'Preview'

    expect(page).to have_css('em', text: 'italic')
    expect(page).to have_css('strong', text: 'bold')
    expect(page).to have_css('a[href$="/users/user"]')
    expect(page).to have_css('img[alt="add-emoji"]')
  end

  scenario 'create', :js do
    visit project_path(nil, project)

    within('#comments_form_section') do
      fill_in 'comment_text', with: comment_text
    end

    within('#comments_form_section') do
      click_on 'Create Comment'
    end

    within('#comments_section') do
      expect(page).to have_text comment_text
    end
  end

  scenario 'reply to a comment', :js do
    visit project_path(nil, project_with_comments)

    within("#comment_#{project_with_comments.comments.first.id}") do
      click_on 'Reply'
    end

    within("#replyCommentcomment_#{project_with_comments.comments.first.id}") do
      fill_in 'comment_text', with: 'You are wrong on the internet!'
    end

    within("#replyCommentcomment_#{project_with_comments.comments.first.id}") do
      click_on 'Create Comment'
    end

    within("#comment_#{project_with_comments.comments.first.id}") do
      expect(page).to have_text 'You are wrong on the internet!'
    end
  end

  scenario 'update', :js do
    comment = create(:comment, commenter: user, commentable: project)

    visit project_path(nil, project)

    within("li#comment_#{comment.id}") do
      click_on 'Edit'
    end

    within("#editCommentcomment_#{comment.id}") do
      fill_in 'comment_text', with: comment_text
      click_on 'Update Comment'
    end

    within("li#comment_#{comment.id}") do
      expect(page).to have_text comment_text
    end
  end
end
