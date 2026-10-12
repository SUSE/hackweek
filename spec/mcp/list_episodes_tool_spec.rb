require 'rails_helper'
require_relative 'spec_helpers'

describe ListEpisodesTool do
  it 'lists episodes with dates and the active flag' do
    create(:episode, name: 'old', start_date: '2020-01-01', end_date: '2020-01-07')
    active = create(:active_episode, name: 'now')

    payload = response_payload(call_tool(described_class, {}, create(:user)))
    flagged = payload.find { |entry| entry['id'] == active.id }

    expect(payload.pluck('title')).to include('old', 'now')
    expect(flagged).to include('active' => true, 'start_date' => active.start_date.iso8601)
    expect(payload.reject { |entry| entry['id'] == active.id }.pluck('active')).to all(be(false))
  end

  it 'is readable for guests' do
    create(:episode)

    response = call_tool(described_class, {}, User.new)

    expect(response.error?).to be(false)
    expect(response_payload(response).length).to eq(1)
  end
end
