require 'rails_helper'

describe ProjectsController do
  let(:admin) { create(:admin) }
  let(:project) { create(:project) }

  before :each do
    sign_in admin
  end

  describe 'GET index' do
    it 'assigns all projects as @projects' do
      get :index
      expect(assigns(:projects)).to eq([project])
    end
  end

  describe 'GET show' do
    it 'assigns the requested project as @project' do
      get :show, params: { id: project.to_param }
      expect(assigns(:project)).to eq(project)
      expect(assigns(:previous_project)).to eq(nil)
      expect(assigns(:next_project)).to eq(nil)
    end

    it 'assigns next and previous project if they exist' do
      previous_project = create(:project)
      project = create(:project)
      next_project =create(:project)

      get :show, params: { id: project.to_param }
      expect(assigns(:previous_project)).to eq(previous_project)
      expect(assigns(:next_project)).to eq(next_project)
    end

    it 'redirects numeric id to slug' do
      get :show, params: { id: project.id }
      expect(response).to redirect_to(project)
    end

    it 'renders the 404 page for non existant projects' do
      get :show, params: { id: 10_000 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET new' do
    it 'assigns a new project as @project' do
      get :new
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested project as @project' do
      get :edit, params: { id: project.to_param }
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Project' do
        expect {
          post :create, params: { project: attributes_for(:project) }
        }.to change(Project, :count).by(1)
      end

      it 'assigns a newly created project as @project' do
        post :create, params: { project: attributes_for(:project) }
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it 'redirects to the created project' do
        post :create, params: { project: attributes_for(:project) }
        expect(response).to redirect_to(Project.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved project as @project' do
        post :create, params: { project: attributes_for(:project, title: nil) }
        expect(assigns(:project)).to be_a_new(Project)
      end

      it 're-renders the "new" template' do
         post :create, params: { project: attributes_for(:project, title: nil) }
         expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) { attributes_for(:project) }

      it 'updates the requested project' do
        put :update, params: { id: project.to_param, project: attributes_for(:project, title: 'whatever') }
        project.reload
        expect(project.title).to eq('whatever')
      end

      it 'assigns the requested project as @project' do
        put :update, params: { id: project.to_param, project: attributes_for(:project) }
        expect(assigns(:project)).to eq(project)
      end

      it 'redirects to the project' do
        put :update, params: { id: project.to_param, project: attributes_for(:project) }
        expect(response).to redirect_to(project)
      end
    end

    describe 'with invalid params' do
      it 'assigns the project as @project' do
        put :update, params: { id: project.to_param, project: attributes_for(:project, title: nil) }
        expect(assigns(:project)).to eq(project)
      end

      it 're-renders the "edit" template' do
        put :update, params: { id: project.to_param, project: attributes_for(:project, title: nil) }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy', search: true do
    it 'destroys the requested project' do
      expect {
        delete :destroy, params: { id: project.to_param }
      }.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      delete :destroy, params: { id: project.to_param }
      expect(response).to redirect_to(projects_url)
    end
  end

  describe 'POST advance_project' do
    it 'advances the projects state' do
      post :advance, params: { id:project.id }
      project.reload
      expect(project.aasm_state).to eq('invention')
    end

    it 'redirects to the project' do
      post :advance, params: { id:project.id }
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST recess_project' do
    it 'recesses the projects state' do
      project = create(:idea)
      post :recess, params: { id:project.id }
      project.reload
      expect(project.aasm_state).to eq('record')
    end

    it 'redirects to the project' do
      project = create(:idea)
      post :recess, params: { id: project.id }
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST join_project' do
    let(:project) { create(:idea) }

    it 'ads an user to the project' do
      expect {
          post :join, params: { id:project.id, format: 'js' }
      }.to change(project.users, :count).by(1)
    end

    context 'when the user already joined' do
      before do
        project.join!(admin)
      end

      it 'does not add the user again' do
        expect {
            post :join, params: { id: project.id, format: 'js' }
        }.not_to change(project.users, :count)
      end
    end
  end

  describe 'GET leave_project' do
    it 'deletes an user from the project' do
      project = create(:idea)
      project.join!(admin)
      expect {
          post :leave, params: { id: project.id, format: 'js' }
      }.to change(project.users, :count).by(-1)
    end
  end

  describe 'GET like_project' do
    it 'likes the projects' do
      expect {
          get :like, params: { id: project.id }
      }.to change(Like, :count).by(1)
    end

    it 'redirects to the project' do
      get :like, params: { id: project.id }
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST dislike_project' do
    it 'dislikes the project' do
      project = create(:idea)
      get :like, params: { id: project.id }
      expect {
          get :dislike, params: { id: project.id }
      }.to change(Like, :count).by(-1)
    end

    it 'redirects to the project' do
      project = create(:idea)
      post :dislike, params: { id: project.id }
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST keyword_project' do
    it 'ads a keyword to the project' do
      project = create(:idea)
      expect {
          post :add_keyword, params: { id: project.id, keyword: 'web' }
      }.to change(Keyword, :count).by(1)
    end

    it 'redirects to the project' do
      project = create(:idea)
      post :add_keyword, params: { id: project.id, keyword: 'web' }
      expect(response).to redirect_to(project)
    end
  end

  describe 'DELETE keyword_project' do
    it 'deletes a keyword from the project' do
      project = create(:idea)
      post :add_keyword, params: { id: project.id, keyword: 'web' }
      expect {
          post :delete_keyword, params: { id: project.id, keyword: 'web' }
      }.to change(project.keywords, :count).by(-1)
    end

    it 'redirects to the project' do
      project = create(:idea)
      post :delete_keyword, params: { id: project.id, keyword: 'web' }
      expect(response).to redirect_to(project)
    end
  end

  describe 'POST episode_project' do
    it 'ads an episode to the project' do
      project = create(:idea)
      episode = create(:episode)

      expect {
          post :add_episode, params: { id: project.id, episode_id: episode.id, format: :js }
      }.to change(project.episodes, :count).by(1)
    end
  end

  describe 'DELETE episode_project' do
    it 'deletes an episode from the project' do
      project = create(:idea)
      episode = create(:episode)
      project.episodes = [episode]

      expect {
          post :delete_episode, params: { id: project.id, episode_id: episode.id, format: :js }
      }.to change(project.episodes, :count).by(-1)
    end
  end

  describe 'GET /:episode/projects.rss' do
    context '.rss' do
      # We want to parse the outputted XML, so let's turn off rendering stubbing
      render_views

      # We are creating our helpers eagerly, so they are in the DB at the request time
      let!(:episode) { create :episode }

      let!(:new_projects) { create_list(:project, 10, episodes: [episode]) }

      before :example do
        get :index, params: { format: :rss }
      end

      it 'returns an RSS feed' do
        expect(response).to be_successful
        expect(response).to render_template('projects/index')
        expect(response.content_type).to eq 'application/rss+xml'
      end

      it 'returns 10 last items' do
        xml = Nokogiri::XML(response.body)
        expect(xml.xpath('//item').count).to eq 10
        expect(xml.xpath('//item/title').map(&:text)).to match_array(new_projects.map(&:title))
      end

      it 'is scoped to an episode' do
        another_episode = create :episode
        the_only_project = create :project, episodes: [another_episode]

        get :index, params: { episode_id: another_episode.id, format: :rss }

        xml = Nokogiri::XML(response.body)
        expect(xml.xpath('//item').count).to eq 1
        expect(xml.xpath('//item/title').map(&:text)).to contain_exactly(the_only_project.title)
      end

      it 'shows the project having lowest projecthits first' do
        project = Project.current(@episode).order('projecthits ASC').first

        get :index, params: { episode_id: episode.id, format: :rss }

        xml = Nokogiri::XML(response.body)
        expect(xml.xpath('//item/title').first.text).to eq project.title
      end

      it 'works when there are EpisodeProductAssociations without timestamp' do
        Project.all.each do |project|
          project.episode_project_associations.update_all(created_at: nil)
        end
        Project.last.destroy
        project = create :project, episodes: [episode]
        project.episode_project_associations.update_all(created_at: 1.year.ago)

        get :index, params: { episode_id: episode.id, format: :rss }

        xml = Nokogiri::XML(response.body)
        expect(xml.xpath('//item').count).to eq 10
        expect(xml.xpath('//item/title').last.text).to eq project.title
      end

      it 'works for :all episodes' do
        expect { get :index, params: {  episode: :all, format: :rss } }.not_to raise_error
      end
    end
  end

  describe 'GET /:episode/projects/random' do
    it 'should render special zoomed template' do
      get :random
      expect(response).to render_template(layout: 'zoomed')
    end

    it 'assigns random project on each request' do
      first_project = create :project
      9.times { create :project }

      expect(Kernel).to receive(:rand).with(Project.count).and_return(0)
      get :random

      expect(assigns(:project)).to eq first_project
    end
  end
end
