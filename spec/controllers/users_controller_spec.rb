require 'rails_helper'

describe UsersController do
  let(:user) { create(:user) }

  before :each do
    sign_in user
  end

  describe 'GET index' do
    it 'assigns all users as @users' do
      get :index
      expect(assigns(:users)).to eq([user])
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST update' do
    it 'updates the user' do
      patch :update, params: { id: user.id, user: {
        location: 'space' } }
      expect(response).to redirect_to(user_path(user.reload))
      expect(user.location).to eq('space')
    end
  end

  describe 'POST add_keyword' do
    it 'ads a keyword to the user' do
      expect {
          post :add_keyword, params: { id: user.id, keyword: 'html' }
      }.to change(Keyword, :count).by(1)
    end
  end

  describe 'DELETE delete_keyword' do
    it 'deletes a keyword from the user' do
      post :add_keyword, params: { id: user.id, keyword: 'javascript' }

      expect {
          delete :delete_keyword, params: { id: user.id, keyword: 'javascript' }
      }.to change(user.keywords, :count).by(-1)
    end
  end
end
