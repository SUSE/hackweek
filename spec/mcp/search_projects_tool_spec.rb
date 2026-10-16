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

  it 'filters through the ability guard when rules deny a project' do
    denied_title = "Denied #{rand(1_000_000)}"
    kept = create(:idea, title: denied_title)
    allowed = create(:idea, title: "#{denied_title} allowed")
    guarded = Ability.new(user)
    allow(guarded).to receive(:can?).and_call_original
    allow(guarded).to receive(:can?).with(:read, allowed).and_return(false)
    allow(Ability).to receive(:new).and_return(guarded)

    payload = response_payload(call_tool(described_class, { query: denied_title }, user))

    expect(payload.pluck('id')).to contain_exactly(kept.id)
  end
end
