require 'rails_helper'

describe ProjectsController do
  before :each do
    sign_in create(:admin)
  end

  describe 'GET index' do
    it 'assigns all projects as @projects' do
      project = create(:project)
      get :index, {}
      expect(assigns(:projects)).to eq([project])
    end
  end

  describe 'GET show' do
    it 'assigns the requested project as @project' do
      project = create(:project)
      get :show, id: project.to_param
      expect(assigns(:project)).to eq(project)
      expect(assigns(:previous_project)).to eq(nil)
      expect(assigns(:next_project)).to eq(nil)
    end

    it 'assigns next and previous project if they exist' do
      previous_project = create(:project)
      project = create(:project)
      next_project =create(:project)

      get :show, id: project.to_param
      expect(assigns(:previous_project)).to eq(previous_project)
      expect(assigns(:next_project)).to eq(next_project)
    end
  end

  describe 'GET new' do
    it 'assigns a new project as @project' do
      get :new, {}
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested project as @project' do
      project = create(:project)
      get :edit, id: project.to_param
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Project' do
        expect {
          post :create, project: attributes_for(:project)
        }.to change(Project, :count).by(1)
      end

      it 'assigns a newly created project as @project' do
        post :create, project: attributes_for(:project)
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it 'redirects to the created project' do
        post :create, project: attributes_for(:project)
        expect(response).to redirect_to(Project.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved project as @project' do
        post :create, project: attributes_for(:project, title: nil)
        expect(assigns(:project)).to be_a_new(Project)
      end

      it 're-renders the "new" template' do
         post :create, project: attributes_for(:project, title: nil)
         expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) { attributes_for(:project) }

      it 'updates the requested project' do
        project = create(:project)
        put :update, id: project.to_param, project: attributes_for(:project, title: 'whatever')
        project.reload
        expect(project.title).to eq('whatever')
      end

      it 'assigns the requested project as @project' do
        project = create(:project)
        put :update, id: project.to_param, project: attributes_for(:project)
        expect(assigns(:project)).to eq(project)
      end

      it 'redirects to the project' do
        project = create(:project)
        put :update, id: project.to_param, project: attributes_for(:project)
        expect(response).to redirect_to(project)
      end
    end

    describe 'with invalid params' do
      it 'assigns the project as @project' do
        project = create(:project)
        put :update, id: project.to_param, project: attributes_for(:project, title: nil)
        expect(assigns(:project)).to eq(project)
      end

      it 're-renders the "edit" template' do
        project = create(:project)
        put :update, id: project.to_param, project: attributes_for(:project, title: nil)
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested project' do
      project = create(:project)
      expect {
        delete :destroy, id: project.to_param
      }.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      project = create(:project)
      delete :destroy, id: project.to_param
      expect(response).to redirect_to(projects_url)
    end
  end

  describe 'POST advance_project' do
    it 'advances the projects state' do
      project = create(:project)
      post :advance, id: project
      project.reload
      expect(project.aasm_state).to eq('invention')
    end

    it 'redirects to the project' do
      project = create(:project)
      post :advance, id: project
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST recess_project' do
    it 'recesses the projects state' do
      project = create(:idea)
      post :recess, id: project
      project.reload
      expect(project.aasm_state).to eq('record')
    end

    it 'redirects to the project' do
      project = create(:idea)
      post :recess, id: project
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST join_project' do
    it 'ads an user to the project' do
      project = create(:idea)
      expect {
          post :join, id: project
      }.to change(project.users, :count).by(1)
    end

    it 'redirects to the project' do
      project = create(:idea)
      post :join, id: project
      expect(response).to redirect_to(project)
    end
  end

  describe 'GET leave_project' do
    it 'deletes an user from the project' do
      project = create(:idea)
      post :join, id: project
      expect {
          post :leave, id: project
      }.to change(project.users, :count).by(-1)
    end

    it 'redirects to the project' do
      project = create(:project)
      post :leave, id: project
      expect(response).to redirect_to(project)
    end
  end

  describe 'GET like_project' do
    it 'likes the projects' do
      project = create(:project)
      expect {
          get :like, id: project
      }.to change(Like, :count).by(1)
    end

    it 'redirects to the project' do
      project = create(:project)
      get :like, id: project
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST dislike_project' do
    it 'dislikes the project' do
      project = create(:idea)
      get :like, id: project
      expect {
          get :dislike, id: project
      }.to change(Like, :count).by(-1)
    end

    it 'redirects to the project' do
      project = create(:idea)
      post :dislike, id: project
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST keyword_project' do
    it 'ads a keyword to the project' do
      project = create(:idea)
      expect {
          post :add_keyword, id: project, keyword: 'web'
      }.to change(Keyword, :count).by(1)
    end

    it 'redirects to the project' do
      project = create(:idea)
      post :add_keyword, id: project, keyword: 'web'
      expect(response).to redirect_to(project)
    end
  end

  describe 'DELETE keyword_project' do
    it 'deletes a keyword from the project' do
      project = create(:idea)
      post :add_keyword, id: project, keyword: 'web'
      expect {
          post :delete_keyword, id: project, keyword: 'web'
      }.to change(project.keywords, :count).by(-1)
    end

    it 'redirects to the project' do
      project = create(:idea)
      post :delete_keyword, id: project, keyword: 'web'
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST episode_project' do
    it 'ads an episode to the project' do
      project = create(:idea)
      episode = create(:episode)
      expect {
          post :add_episode, id: project, episode_id: episode.id
      }.to change(project.episodes, :count).by(1)
    end

    it 'redirects to the project' do
      project = create(:idea)
      episode = create(:episode)
      post :add_episode, id: project, episode_id: episode.id
      expect(response).to redirect_to(project_url(episode, project))
    end
  end

  describe 'DELETE episode_project' do
    it 'deletes an episode from the project' do
      project = create(:idea)
      episode = create(:episode)
      post :add_episode, id: project, episode_id: episode.id
      expect {
          post :delete_episode, id: project, episode_id: episode.id
      }.to change(project.episodes, :count).by(-1)
    end

    it 'redirects to the project' do
      project = create(:idea)
      episode = create(:episode)
      post :add_episode, id: project, episode_id: episode.id
      post :delete_episode, id: project, episode_id: episode.id
      expect(response).to redirect_to(project)
    end
  end

  describe 'GET /:episode/projects/newest' do
    context '.rss' do

      # We want to parse the outputted XML, so let's turn off rendering stubbing
      render_views

      # We are creating our helpers eagerly, so they are in the DB at the request time
      let!(:episode) { create :episode }
      let!(:old_projects) do
        Timecop.freeze (1.year.ago) do
          (1..12).map { create :project, episodes: [episode] }
        end
      end
      let!(:new_projects) { (1..10).map { create :project, episodes: [episode] } }

      before :example do
        get :newest, format: :rss
      end

      it 'returns an RSS feed' do
        expect(response).to be_success
        expect(response).to render_template('projects/newest')
        expect(response.content_type).to eq 'application/rss+xml'
      end

      it 'returns 10 last items' do
        xml = Nokogiri::XML(response.body)
        expect(xml.xpath('//item').count).to eq 10
        expect(xml.xpath('//item/title').map &:text).to match_array(new_projects.map &:title)
      end

      it 'is scoped to an episode' do
        another_episode = create :episode
        the_only_project = create :project, episodes: [another_episode]

        get :newest, episode_id: another_episode, format: :rss

        xml = Nokogiri::XML(response.body)
        expect(xml.xpath('//item').count).to eq 1
        expect(xml.xpath('//item/title').map &:text).to contain_exactly(the_only_project.title)
      end

      it 'is updated when the project is added to an episode' do
        project = create :project, created_at: 1.year.ago

        post :add_episode, id: project, episode_id: episode.id
        get :newest, episode_id: episode.id, format: :rss

        xml = Nokogiri::XML(response.body)
        expect(xml.xpath('//item/title').first.text).to eq project.title
      end

      it 'works when there are EpisodeProductAssociations without timestamp' do
        Project.all.each do |project|
          project.episode_project_associations.update_all(created_at: nil)
        end

        project = create :project, episodes: [episode]
        project.episode_project_associations.update_all(created_at: 1.year.ago)

        get :newest, episode_id: episode.id, format: :rss

        xml = Nokogiri::XML(response.body)
        expect(xml.xpath('//item').count).to eq 10
        expect(xml.xpath('//item/title').first.text).to eq project.title
      end
    end
  end
end
