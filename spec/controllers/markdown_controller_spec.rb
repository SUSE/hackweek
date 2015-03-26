require 'rails_helper'

RSpec.describe MarkdownController, type: :controller do

  describe "GET #preview" do
    it "returns http success" do
      get :preview
      expect(response).to have_http_status(:success)
    end
  end

end
