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
    click_button "Create Project"

    expect(page).to have_text("an idea by #{user.name}")
  end
end
