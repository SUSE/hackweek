require 'rails_helper'

feature 'Collaboration' do
  scenario 'User joins a project' do
    user = create(:user)
    project = create(:idea)
    sign_in user

    visit "/projects/#{project.to_param}"

    expect {
      click_link 'Join this project'
    }.to change(Project.populated, :count).by(1)
    expect(page).to have_css("#user#{user.id}-gravatar")
    expect(page).to have_text("Welcome to the project #{user.name}!")
  end

  scenario 'User leaves a project' do
    user = create(:user)
    project = create(:project, users: [user])
    sign_in user

    visit "/projects/#{project.to_param}"
    click_link 'Leave this project'

    expect(page).not_to have_css("#user#{user.id}-gravatar")
  end

  scenario 'User likes a project' do
    user = create(:user)
    project = create(:idea)
    sign_in user

    visit "/projects/#{project.to_param}"

    expect {
      click_link "like-#{project.to_param}"
    }.to change(Project.liked, :count).by(1)
    expect(page).not_to have_css("like-#{project.to_param}")
  end

  scenario 'User dislikes a project' do
    user = create(:user)
    project = create(:idea)
    sign_in user

    visit "/projects/#{project.to_param}"
    click_link "like-#{project.to_param}"

    expect {
      click_link "dislike-#{project.to_param}"
    }.to change(Project.liked, :count).by(-1)
    expect(page).not_to have_css("dislike-#{project.to_param}")
  end
end
