require 'rails_helper'

RSpec.describe Projects::ProjectFollowsController, type: :controller do
  let(:user) { create :user }
  let(:episode) { create :episode }
  let(:project) { create :project }

  before :each do
    sign_in user
  end

  describe 'POST create' do
    it 'creates a unique project_follow' do
      expect do
        post :create, params: { project_id: project, format: :js }
      end.to change(ProjectFollow, :count).by(1)
      expect do
        post :create, params: { project_id: project, format: :js }
      end.to change(ProjectFollow, :count).by(0)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes a project_follow entry' do
      post :create, params: { project_id: project, episode: episode, format: :js }
      expect do
        delete :destroy, params: { project_id: project, episode: episode, format: :js }
      end.to change(ProjectFollow, :count).by(-1)
    end
  end
end
