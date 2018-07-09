require 'rails_helper'

feature 'Collaboration' do
  scenario 'User joins a project', :js do
    user = create(:user)
    project = create(:idea)
    sign_in user

    visit project_path(nil, project)

    click_link 'Join this project'
    expect(page).to have_css("#user#{user.id}-gravatar")
    expect(page).to have_text("Welcome to the project #{user.name}.")
  end

  scenario 'User leaves a project', :js do
    user = create(:user)
    project = create(:project, users: [user])
    sign_in user

    visit project_path(nil, project)
    click_link 'Leave this project'

    expect(page).not_to have_css("#user#{user.id}-gravatar")
    expect(page).to have_text("Sorry to see you go #{user.name}.")
  end

  scenario 'User likes a project' do
    user = create(:user)
    project = create(:idea)
    sign_in user

    visit project_path(nil, project)

    expect {
      click_link "like-#{project.id}"
    }.to change(Project.liked, :count).by(1)
    expect(page).not_to have_css("like-#{project.id}")
  end

  scenario 'User dislikes a project' do
    user = create(:user)
    project = create(:idea)
    sign_in user

    visit project_path(nil, project)
    click_link "like-#{project.id}"

    expect {
      click_link "dislike-#{project.id}"
    }.to change(Project.liked, :count).by(-1)
    expect(page).not_to have_css("dislike-#{project.id}")
  end

  scenario 'User likes a project multiple times' do
    user = create(:user)
    project = create(:idea)
    sign_in user

    visit project_path(nil, project)
    click_link "like-#{project.id}"

    expect {
      find("#like-#{project.id}", visible: false).click
    }.to change(Project.liked, :count).by(0)
    expect(page).not_to have_css("like-#{project.id}")
  end
end
