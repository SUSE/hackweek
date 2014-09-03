require 'rails_helper'

feature "Collaboration" do
  scenario "User creates a new project" do
    project = create(:idea)
    user = create(:user)
    sign_in user

    visit "/projects/#{project.to_param}"

    click_link "Join this project"
    expect(page).to have_text("Welcome to the project #{user.name}!")
  end
end