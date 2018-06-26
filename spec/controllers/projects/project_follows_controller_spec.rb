require 'rails_helper'

RSpec.describe Projects::ProjectFollowsController, type: :controller do
  let(:user) { create :user }
  let(:episode) { create :episode }
  let(:project) { create :project }

  before :each do
    sign_in user
  end

  describe 'GET create' do
    it 'creates a unique project_follow' do
      expect {
        post :create, project_id: project.id, episode: episode
      }.to change(ProjectFollow, :count).by(1)
      expect {
        post :create, project_id: project.id, episode: episode
      }.to change(ProjectFollow, :count).by(0)
    end
  end

  describe 'GET destroy' do
    it 'deletes a project_follow entry' do
      post :create, project_id: project.id, episode: episode
      expect {
        delete :destroy, project_id: project.id, episode: episode
      }.to change(ProjectFollow, :count).by(-1)
    end
  end
end
