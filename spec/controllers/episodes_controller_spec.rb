require 'rails_helper'

describe EpisodesController do
  before :each do
    sign_in create(:admin)
  end

  describe 'GET index' do
    it 'assigns all episodes as @episodes' do
      episode = create(:episode)
      get :index
      expect(assigns(:episodes)).to eq([episode])
    end
  end

  describe 'GET show' do
    it 'assigns the requested episode as @episode' do
      episode = create(:episode)
      get :show, params: { id: episode.to_param }
      expect(assigns(:episode)).to eq(episode)
    end
  end

  describe 'GET new' do
    it 'assigns a new episode as @episode' do
      get :new
      expect(assigns(:episode)).to be_a_new(Episode)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested episode as @episode' do
      episode = create(:episode)
      get :edit, params: { id: episode.to_param }
      expect(assigns(:episode)).to eq(episode)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Episode' do
        expect {
          post :create, params: { episode: attributes_for(:episode) }
        }.to change(Episode, :count).by(1)
      end

      it 'assigns a newly created episode as @episode' do
        post :create, params: { episode: attributes_for(:episode) }
        expect(assigns(:episode)).to be_a(Episode)
        expect(assigns(:episode)).to be_persisted
      end

      it 'redirects to the episodes list' do
        post :create, params: { episode: attributes_for(:episode) }
        expect(response).to redirect_to(episodes_url)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved episode as @episode' do
        post :create, params: { episode: attributes_for(:episode, name: nil) }
        expect(assigns(:episode)).to be_a_new(Episode)
      end

      it 're-renders the "new" template' do
         post :create, params: { episode: attributes_for(:episode, name: nil) }
         expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) { attributes_for(:episode) }

      it 'updates the requested episode' do
        episode = create(:episode)
        put :update, params: { id: episode.to_param, episode: attributes_for(:episode, name: 'whatever') }
        episode.reload
        expect(episode.name).to eq('whatever')
      end

      it 'assigns the requested episode as @episode' do
        episode = create(:episode)
        put :update, params: { id: episode.to_param, episode: attributes_for(:episode) }
        expect(assigns(:episode)).to eq(episode)
      end

      it 'redirects to the episodes list' do
        episode = create(:episode)
        put :update, params: { id: episode.to_param, episode: attributes_for(:episode) }
        expect(response).to redirect_to(episodes_url)
      end
    end

    describe 'with invalid params' do
      it 'assigns the episode as @episode' do
        episode = create(:episode)
        put :update, params: { id: episode.to_param, episode: attributes_for(:episode, name: nil) }
        expect(assigns(:episode)).to eq(episode)
      end

      it 're-renders the "edit" template' do
        episode = create(:episode)
        put :update, params: { id: episode.to_param, episode: attributes_for(:episode, name: nil) }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested episode' do
      episode = create(:episode)
      expect {
        delete :destroy, params: { id: episode.to_param }
      }.to change(Episode, :count).by(-1)
    end

    it 'redirects to the episodes list' do
      episode = create(:episode)
      delete :destroy, params: { id: episode.to_param }
      expect(response).to redirect_to(episodes_url)
    end
  end
end
