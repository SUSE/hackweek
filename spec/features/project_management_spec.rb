require 'rails_helper'

feature "Project management" do
  scenario "User creates a new project" do
    user = create(:user)
    sign_in user
    title = Faker::Lorem.sentence
    description = Faker::Lorem.paragraph

    visit "/projects/new"

    fill_in "project_title", :with => title
    fill_in "project_description", :with => description
    
    expect {
      click_button "Create Project"
    }.to change(Project, :count).by(1)
    expect(page).to have_text("an idea by #{user.name}")
    expect(page).to have_text(title)
    expect(page).to have_text(description)  
  end

  scenario "User edits a project" do
    user = create(:user)
    project = create(:idea, originator: user )
    sign_in user
    title = Faker::Lorem.sentence
    description = Faker::Lorem.paragraph

    visit "/projects/#{project.to_param}/edit"

    fill_in "project_title", :with => title
    fill_in "project_description", :with => description
    click_button "Update Project"

    expect(page).to have_text("an idea by #{user.name}")
    expect(page).to have_text(title)
    expect(page).to have_text(description)
  end

  scenario "User deletes a project" do
    user = create(:user)
    project = create(:idea, originator: user )
    sign_in user

    visit "/projects/#{project.to_param}"

    expect {
      click_link "project#{project.to_param}-delete-link"
    }.to change(Project, :count).by(-1)
  end

  scenario "User archives an idea" do
    user = create(:user)
    project = create(:idea, originator: user )
    sign_in user

    visit "/projects/#{project.to_param}"

    expect {
      click_link "project#{project.to_param}-recess-link"
    }.to change(Project.archived, :count).by(1)
  end

  scenario "User finishes a project" do
    user = create(:user)
    project = create(:project, originator: user, users: [user] )
    sign_in user

    visit "/projects/#{project.to_param}"

    expect {
      click_link "project#{project.to_param}-advance-link"
    }.to change(Project.finished, :count).by(1)
  end

  scenario "User restarts a project" do
    user = create(:user)
    project = create(:invention, originator: user, users: [user] )

    sign_in user
    visit "/projects/#{project.to_param}"
    click_link "project#{project.to_param}-recess-link"

    project.reload
    expect(project.aasm_state).to eq('project')
  end

end
