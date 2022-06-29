require 'rails_helper'

feature 'Comment' do
  let(:user) { create :user }

  before :each do
    sign_in user
  end

  scenario 'markdown preview', :js do
    project = create(:invention, originator: user, users: [user])

    visit project_path(:all, project)
    fill_in 'comment_text', with: '_italic_ **bold** :smile: @user'
    click_link 'Preview'

    expect(page).to have_css('em', text: 'italic')
    expect(page).to have_css('strong', text: 'bold')
    expect(page).to have_css('a[href$="/users/user"]')
    expect(page).to have_css('img[alt="add-emoji"]')
  end

  scenario 'create', :js do
    project = create(:idea, originator: user)
    comment_text = Faker::Lorem.sentence

    visit project_path(nil, project)
    within('#comments_form_section') do
      fill_in 'comment_text', with: comment_text
    end

    expect do
      within('#comments_form_section') do
        click_button 'Create Comment'
      end
    end.to change(project.comments, :count).by(1)
    expect(page).to have_text comment_text
  end

  scenario 'reply to a comment', :js do
    project = create(:idea, :with_comments, originator: user)
    reply_text = 'You are wrong on the internet!'
    first_comment = project.comments.first

    visit project_path(nil, project)

    within("li#comment_#{first_comment.id}") do
      click_link 'Reply'
    end

    within("#replyCommentcomment_#{first_comment.id}") do
      fill_in 'comment_text', with: reply_text
    end

    expect do
      within("#replyCommentcomment_#{first_comment.id}") do
        click_button 'Create Comment'
      end
    end.to change(first_comment.comments, :count).by(1)
  end

  scenario 'update', :js do
    project = create(:idea, originator: user)
    comment = create(:comment, commenter: user, commentable: project)
    update_text = Faker::Lorem.sentence

    visit project_path(nil, project)

    within("li#comment_#{comment.id}") do
      click_link 'Edit'
    end

    within("#editCommentcomment_#{comment.id}") do
      fill_in 'comment_text', with: update_text
      click_button 'Update Comment'
    end

    within("li#comment_#{comment.id}") do
      expect(page).to have_text update_text
    end
  end
end
