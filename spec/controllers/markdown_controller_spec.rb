require 'rails_helper'

RSpec.describe MarkdownController, type: :controller do
  render_views

  describe 'GET #preview' do
    it 'renders a markdown preview' do
      sign_in create :user
      get :preview, xhr: true, params: { source: '**hans**' }
      expect(response.body).to include('$(\'# .preview-contents\').html("<p><strong>hans<\/strong><\/p>\n\n");')
    end
  end
end
