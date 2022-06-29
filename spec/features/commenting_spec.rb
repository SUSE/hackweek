require 'rails_helper'

feature 'Commenting' do
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

  scenario 'create a comment', :js do
    project = create(:idea, originator: user)
    comment_text = Faker::Lorem.sentence

    visit project_path(nil, project)
    expect do
      click_button 'Add Comment', match: :first
    end.to change(first_comment.comments, :count).by(1)
    expect(page).to have_text comment_text
  end

  scenario 'reply to a comment', :js do
    project = create(:idea, :with_comments, originator: user)
    reply_text = Faker::Lorem.sentence

    visit project_path(nil, project)
    first_comment = project.comments.first
    click_link 'Reply', match: :first

    expect(page).to have_text first_comment.text
    expect(page).to have_css('#replyModal.modal.in')

    @modal = find '.modal.fade.in'
    @modal.find("textarea[id$='comment_text']").set reply_text

    expect do
      @modal.find('button[name="button"]').click
    end.to change(first_comment.comments, :count).by(1)
  end

  scenario 'update a comment', :js do
    project = create(:idea, :with_comments, originator: user)
    reply_text = Faker::Lorem.sentence

    visit project_path(nil, project)
    first_comment = project.comments.first
    click_link 'Edit', match: :first

    expect(page).to have_text first_comment.text
    expect(page).to have_css('#editComment.modal.in')

    @modal = find '.modal.fade.in'
    @modal.find("textarea[id$='comment_text']").set reply_text

    @modal.find('button[name="button"]').click
    expect(page).to have_text reply_text
    expect(page).to.not have_text first_comment.text
  end
end
