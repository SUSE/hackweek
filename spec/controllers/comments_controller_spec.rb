require 'rails_helper'

describe CommentsController do
  let(:user) { create(:admin) }

  before do
    sign_in user
  end

  describe 'GET index' do
    let!(:ham_comment) { create(:comment, ham: true) }

    before { create(:comment) }

    it 'assigns un-moderated comments as @comments' do
      get :index
      expect(assigns(:comments)).not_to include(ham_comment)
    end
  end

  describe 'POST mark_as_ham' do
    let(:comment) { create(:comment) }

    it 'marks the comment as ham' do
      patch :mark_as_ham, params: { id: comment.id }
      expect(comment.reload.ham).to be_truthy
    end
  end
end
