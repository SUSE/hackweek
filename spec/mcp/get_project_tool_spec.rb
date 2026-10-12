require 'rails_helper'
require_relative 'spec_helpers'

describe GetProjectTool do
  let(:user) { create(:user) }
  let(:project) { create(:project, originator: user) }

  before do
    project.keywords << Keyword.create!(name: 'testing')
    Update.create!(author: user, project: project, text: 'mine')
  end

  it 'returns title, state, originator, members, keywords and updates' do
    payload = response_payload(call_tool(described_class, { id: project.url }, user))

    expect(payload).to include(
      'title' => project.title,
      'state' => project.aasm_state,
      'originator' => user.name,
      'keywords' => ['testing']
    )
    expect(payload['members']).to include(*project.users.map(&:name))
    expect(payload['recent_updates'].pluck('text')).to include('mine')
  end

  it 'denies uniformly for an unknown id' do
    expect(call_tool(described_class, { id: 'no-such-project' }, user)).to be_denied
  end

  it 'hides updates authored by other users' do
    other = create(:user)
    Update.create!(author: other, project: project, text: 'theirs')

    payload = response_payload(call_tool(described_class, { id: project.url }, user))
    texts = payload['recent_updates'].pluck('text')

    expect(texts).to include('mine')
    expect(texts).not_to include('theirs')
  end

  it 'shows others updates to their author' do
    other = create(:user)
    Update.create!(author: other, project: project, text: 'theirs')

    payload = response_payload(call_tool(described_class, { id: project.url }, other))

    expect(payload['recent_updates'].pluck('text')).to include('theirs')
  end

  it 'is readable for guests but suppresses update texts' do
    response = call_tool(described_class, { id: project.url }, User.new)

    expect(response.error?).to be(false)
    expect(response_payload(response)['recent_updates']).to be_empty
  end
end
