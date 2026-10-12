require 'rails_helper'
require_relative 'spec_helpers'

describe SearchProjectsTool do
  let(:user) { create(:user) }

  before do
    create(:idea, title: 'Time machine for tacos', description: 'A plain project')
    create(:idea, title: 'A plain project', description: 'Delicious taco catering service')
    keyword_project = create(:idea, title: 'A plain project', description: 'Nothing special')
    keyword_project.keywords << Keyword.create!(name: 'tacostand')
    create(:idea, title: 'Unrelated work', description: 'Nothing to find here')
  end

  it 'matches titles' do
    payload = response_payload(call_tool(described_class, { query: 'time machine' }, user))

    expect(payload.pluck('title')).to contain_exactly('Time machine for tacos')
  end

  it 'matches descriptions' do
    payload = response_payload(call_tool(described_class, { query: 'catering' }, user))

    expect(payload.length).to eq(1)
  end

  it 'matches keywords' do
    payload = response_payload(call_tool(described_class, { query: 'tacostand' }, user))

    expect(payload.length).to eq(1)
  end

  it 'returns an empty list without matches' do
    payload = response_payload(call_tool(described_class, { query: 'zzz-no-match' }, user))

    expect(payload).to be_empty
  end

  it 'is readable for guests' do
    response = call_tool(described_class, { query: 'taco' }, User.new)

    expect(response.error?).to be(false)
    expect(response_payload(response).length).to eq(3)
  end
end
