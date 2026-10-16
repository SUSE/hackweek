require 'rails_helper'

describe 'users/edit.html.haml' do
  include Devise::Test::ControllerHelpers

  let(:owner) { create(:user) }

  before do
    sign_in owner
    assign(:api_tokens, [])
  end

  it 'shows the tokens section on your own profile' do
    assign(:user, owner)

    render

    expect(rendered).to include('API tokens')
  end

  it 'hides the tokens section on another profile' do
    assign(:user, create(:user))

    render

    expect(rendered).not_to include('API tokens')
  end
end
