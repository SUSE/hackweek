require 'rails_helper'
require_relative 'spec_helpers'

describe ListProjectsTool do
  let(:user) { create(:user) }

  it 'lists projects scoped to the active episode by default' do
    other_episode = create(:episode)
    elsewhere = create(:idea)
    elsewhere.episodes << other_episode
    create(:active_episode)
    active_project = create(:idea)

    payload = response_payload(call_tool(described_class, {}, user))

    expect(payload.pluck('id')).to contain_exactly(active_project.id)
  end

  it 'lists every project for episode all' do
    create(:episode)
    first = create(:idea)
    second = create(:idea)

    payload = response_payload(call_tool(described_class, { episode: 'all' }, user))

    expect(payload.pluck('id')).to contain_exactly(first.id, second.id)
  end

  it 'scopes to the given episode id' do
    other_episode = create(:episode)
    elsewhere = create(:idea)
    elsewhere.episodes << other_episode
    create(:idea)

    payload = response_payload(call_tool(described_class, { episode: other_episode.id }, user))

    expect(payload.pluck('id')).to contain_exactly(elsewhere.id)
  end

  it 'returns an error for an unknown episode' do
    create(:idea)

    response = call_tool(described_class, { episode: 999_999 }, user)

    expect(response.error?).to be(true)
    expect(response).not_to be_denied
  end

  it 'caps the number of returned projects' do
    create_list(:idea, 3)

    payload = response_payload(call_tool(described_class, { episode: 'all', limit: 2 }, user))

    expect(payload.length).to eq(2)
  end

  it 'returns id, title, url, state, originator and member count' do
    project = create(:project)

    payload = response_payload(call_tool(described_class, { episode: 'all' }, User.new))

    expect(payload.first).to include(
      'id' => project.id,
      'title' => project.title,
      'url' => project.url,
      'state' => project.aasm_state,
      'originator' => project.originator.name,
      'member_count' => 1
    )
  end
end
