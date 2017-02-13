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
end
