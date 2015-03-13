require 'rails_helper'

describe ApiController do
  before :each do
    sign_in create(:admin)
  end

  describe 'POST api_import' do
    it 'imports projects' do
      json = <<EOT
{
  "projects": [
    {
      "title": "GitCool",
      "description": "Here will be a description."
    },
    {
      "title": "Github-Pages-Jekyll-Templates",
      "description": "Here will be a description."
    },
    {
      "title": "Dashoid",
      "description": "Here will be a description."
    }
  ]
}
EOT
      expect { post :import, json }.to change(Project, :count).by(3)
    end
  end
end
