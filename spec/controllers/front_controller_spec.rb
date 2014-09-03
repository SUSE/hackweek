require 'rails_helper'

describe EpisodesController do
  it 'renders the index' do
    get :index
    expect(response.response_code).to eq(200)
  end
end
