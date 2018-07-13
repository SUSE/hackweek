require 'rails_helper'

RSpec.describe MarkdownController, type: :controller do
  describe 'GET #preview' do
    it 'correctly assigns rendered html' do
      source = '*italic*'

      get :preview, xhr: true, params: { source: source }

      expect(response).to have_http_status(:success)
      expect(assigns(:rendered)).to eq "<p><em>italic</em></p>\n"
    end
  end
end
