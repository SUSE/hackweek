require 'rails_helper'
require_relative 'spec_helpers'

describe MyProjectsTool do
  let(:user) { create(:user) }

  it 'denies uniformly for guests' do
    expect(call_tool(described_class, {}, User.new)).to be_denied
  end

  it 'returns originated and member projects with roles' do
    originated = create(:idea, originator: user)
    other = create(:user)
    membered = create(:project, originator: other, users: [user])
    create(:idea, originator: other)

    payload = response_payload(call_tool(described_class, {}, user))
    by_id = payload.index_by { |entry| entry['id'] }

    expect(by_id.keys).to contain_exactly(originated.id, membered.id)
    expect(by_id[originated.id]).to include('title' => originated.title, 'role' => 'originator')
    expect(by_id[membered.id]['role']).to eq('member')
  end

  it 'returns an empty list without projects' do
    payload = response_payload(call_tool(described_class, {}, user))

    expect(payload).to be_empty
  end
end
