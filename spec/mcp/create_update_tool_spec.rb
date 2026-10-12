require 'rails_helper'
require_relative 'spec_helpers'

describe CreateUpdateTool do
  let(:user) { create(:user) }
  let(:project) { create(:idea, originator: user) }

  it 'creates an update for the originator' do
    response = call_tool(described_class, { project_id: project.id, text: 'progress!' }, user)

    expect(response.error?).to be(false)
    expect(project.updates.where(author: user, text: 'progress!').count).to eq(1)
  end

  it 'creates an update for a member' do
    membered = create(:project, users: [user])

    response = call_tool(described_class, { project_id: membered.url, text: 'helping' }, user)

    expect(response.error?).to be(false)
  end

  it 'denies uniformly for other users' do
    stranger = create(:user)
    denied_id = project.id
    response = nil
    expect do
      response = call_tool(described_class, { project_id: denied_id, text: 'hijack' }, stranger)
    end.not_to change(Update, :count)

    expect(response).to be_denied
  end

  it 'denies uniformly for guests' do
    expect(call_tool(described_class, { project_id: project.id, text: 'hi' }, User.new)).to be_denied
  end

  it 'denies uniformly for unknown projects' do
    expect(call_tool(described_class, { project_id: 999_999, text: 'hi' }, user)).to be_denied
  end

  it 'returns an error response on validation failure' do
    project_id = project.id
    invalid = Update.new
    invalid.validate
    allow(Update).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(invalid))

    response = call_tool(described_class, { project_id: project_id, text: 'boom' }, user)

    expect(response.error?).to be(true)
  end
end
