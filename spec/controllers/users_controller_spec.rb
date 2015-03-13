require 'rails_helper'

describe UsersController do
  before :each do
    @admin = create(:admin)
    sign_in @admin
  end

  describe 'GET index' do
    it 'assigns all users as @users' do
      get :index, {}
      expect(assigns(:users)).to eq([@admin])
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      get :show, id: @admin.to_param
      expect(assigns(:user)).to eq(@admin)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested user as @user' do
      get :edit, id: @admin.to_param
      expect(assigns(:user)).to eq(@admin)
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested user' do
        admin = @admin.as_json
        admin[:name] = 'whatever'
        put :update, id: @admin.to_param, user: admin
        @admin.reload
        expect(@admin.name).to eq('whatever')
      end

      it 'assigns the requested user as @user' do
        user = create(:user)
        put :update, id: user.to_param, user: attributes_for(:user)
        expect(assigns(:user)).to eq(user)
      end

      it 'redirects to the user' do
        user = create(:user)
        put :update, id: user.to_param, user: attributes_for(:user)
        expect(response).to redirect_to(:me_users)
      end
    end

    describe 'with invalid params' do
      it 'assigns the user as @user' do
        user = create(:user)
        put :update, id: user.to_param, user: attributes_for(:user, name: nil)
        expect(assigns(:user)).to eq(user)
      end

      it 're-renders the "edit" template' do
        user = create(:user)
        put :update, id: user.to_param, user: attributes_for(:user, name: nil)
        expect(response).to render_template('edit')
      end
    end
  end
end
