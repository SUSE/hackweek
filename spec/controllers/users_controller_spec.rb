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
        location: 'space'
      } }
      expect(response).to redirect_to(user_path(user.reload))
      expect(user.location).to eq('space')
    end
  end

  describe 'POST add_keyword' do
    it 'ads a keyword to the user' do
      expect do
        post :add_keyword, params: { id: user.id, keyword: 'html' }
      end.to change(Keyword, :count).by(1)
    end
  end

  describe 'DELETE delete_keyword' do
    it 'deletes a keyword from the user' do
      post :add_keyword, params: { id: user.id, keyword: 'javascript' }

      expect do
        delete :delete_keyword, params: { id: user.id, keyword: 'javascript' }
      end.to change(user.keywords, :count).by(-1)
    end
  end

  describe 'API tokens' do
    let(:other) { create(:user) }

    describe 'GET tokens' do
      it 'scopes listing to the requester on cross-user paths' do
        ApiToken.create!(user: other, name: 'victim')
        ApiToken.create!(user: user, name: 'mine')

        get :tokens, params: { id: other.id }

        expect(assigns(:user)).to eq(user)
        expect(assigns(:api_tokens).map(&:name)).to contain_exactly('mine')
      end
    end

    describe 'POST create_token' do
      it 'mints for the requester even on cross-user paths' do
        expect do
          post :create_token, params: { id: other.id, name: 'x', scope: 'read' }
        end.to change(user.api_tokens, :count).by(1)

        expect(other.api_tokens.count).to eq(0)
        expect(ApiToken.last.user).to eq(user)
      end

      it 'rejects invalid scope with 422' do
        post :create_token, params: { id: user.id, name: 'x', scope: 'admin' }

        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'rejects blank name with 422' do
        post :create_token, params: { id: user.id, name: '', scope: 'read' }

        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'rejects overlong name with 422' do
        post :create_token, params: { id: user.id, name: 'x' * 256, scope: 'read' }

        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'caps minting at 50 per user' do
        50.times { |i| ApiToken.create!(user: user, name: "t#{i}") }

        expect do
          post :create_token, params: { id: user.id, name: 'one-too-many', scope: 'read' }
        end.not_to change(ApiToken, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe 'DELETE revoke_token' do
      it 'revokes only the owner token' do
        token = ApiToken.create!(user: user, name: 'mine')

        delete :revoke_token, params: { id: user.id, token_id: token.id }

        expect(token.reload.revoked?).to be(true)
      end

      it 'does not revoke another user token' do
        victim_token = ApiToken.create!(user: other, name: 'victim')

        delete :revoke_token, params: { id: other.id, token_id: victim_token.id }

        expect(victim_token.reload.revoked?).to be(false)
        expect(response).to redirect_to(tokens_user_path(user))
        expect(flash[:alert]).to be_present
      end

      it 'redirects with alert when already gone' do
        delete :revoke_token, params: { id: user.id, token_id: 999_999 }

        expect(response).to redirect_to(tokens_user_path(user))
        expect(flash[:alert]).to be_present
      end

      it 'forbids cross-user revoke even for admins' do
        admin = create(:admin)
        sign_in admin
        victim_token = ApiToken.create!(user: other, name: 'victim')

        delete :revoke_token, params: { id: other.id, token_id: victim_token.id }

        expect(victim_token.reload.revoked?).to be(false)
        expect(ApiToken.where(user: admin).count).to eq(0)
      end
    end
  end
end
