require 'rails_helper'

RSpec.describe MarkdownController, type: :controller do

  describe 'GET #preview' do
    it 'correctly assigns rendered html' do
      source = '*italic*'

      xhr :get, :preview, format: :js, source: source

      expect(response).to have_http_status(:success)
      expect(assigns(:rendered)).to eq "<p><em>italic</em></p>\n"
    end
  end

end
