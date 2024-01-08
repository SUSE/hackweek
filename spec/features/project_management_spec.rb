require 'rails_helper'

feature 'Project management' do
  let(:user) { create :user }

  before :each do
    sign_in user
  end

  scenario 'User creates a new project' do
    title = Faker::Lorem.sentence
    description = Faker::Lorem.paragraph

    visit new_project_path

    fill_in 'project_title', with: title
    fill_in 'project_description', with: description

    expect do
      click_on 'Create Project'
    end.to change(Project, :count).by(1)
    expect(page).to have_text("an idea by #{user.name}")
    expect(page).to have_text(title)
    expect(page).to have_text(description)
  end

  scenario 'User edits a project' do
    project = create(:idea, originator: user)

    title = Faker::Lorem.sentence
    description = Faker::Lorem.paragraph

    visit edit_project_path(nil, project)
    expect(page).to have_text(project.description)

    fill_in 'project_title', with: title
    fill_in 'project_description', with: description
    click_on 'Update Project'

    expect(page).to have_text("an idea by #{user.name}")
    expect(page).to have_text(title)
    expect(page).to have_text(description)
  end

  scenario 'User deletes a project', :search do
    project = create(:idea, originator: user)

    visit project_path(nil, project)

    expect do
      click_on "project#{project.to_param}-delete-link"
    end.to change(Project, :count).by(-1)
  end

  scenario 'User archives an idea' do
    project = create(:idea, originator: user)

    visit project_path(nil, project)

    expect do
      click_on "project#{project.to_param}-recess-link"
    end.to change(Project.archived, :count).by(1)
  end

  scenario 'User finishes a project' do
    project = create(:project, originator: user, users: [user])

    visit project_path(nil, project)

    expect do
      click_on "project#{project.to_param}-advance-link"
    end.to change(Project.finished, :count).by(1)
  end

  scenario 'User restarts a project' do
    project = create(:invention, originator: user, users: [user])

    visit project_path(nil, project)
    click_on "project#{project.to_param}-recess-link"

    project.reload
    expect(project.aasm_state).to eq('project')
  end

  scenario 'User uses markdown preview button during editing', :js do
    visit '/projects/new'
    fill_in 'project_description', with: '_italic_ **bold**'
    click_on 'Preview'

    expect(page).to have_css('em', text: 'italic')
    expect(page).to have_css('strong', text: 'bold')
  end

  scenario 'more than one project having same tags' do
    project = create(:project, originator: user)
    project2 = create(:project, originator: user)
    project.add_keyword! 'web', user
    project2.add_keyword! 'web', user

    visit project_path(nil, project)

    expect(page).to have_css('h5', text: project2.title)
  end
end
