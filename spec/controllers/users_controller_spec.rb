require 'rails_helper'

describe UsersController do
  let(:user) { create(:user) }

  before :each do
    sign_in user
  end

  describe 'GET index' do
    it 'assigns all users as @users' do
      get :index, {}
      expect(assigns(:users)).to eq([user])
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST update' do
    it 'updates the user' do
      patch :update, id: user.id, user: {
        location: 'space', name: 'John Doe', email: 'john@space.org' }
      expect(response).to redirect_to(user_path(user.reload))
      expect(user.location).to eq('space')
      expect(user.name).to eq('John Doe')
      expect(user.email).to eq('john@space.org')
    end
  end

  describe 'POST add_keyword' do
    it 'ads a keyword to the user' do
      expect {
          post :add_keyword, id: user.id, keyword: 'html'
      }.to change(Keyword, :count).by(1)
    end
  end

  describe 'DELETE delete_keyword' do
    it 'deletes a keyword from the user' do
      post :add_keyword, id: user.id, keyword: 'javascript'

      expect {
          delete :delete_keyword, id:user.id, keyword: 'javascript'
      }.to change(user.keywords, :count).by(-1)
    end
  end
end
