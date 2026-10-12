require 'rails_helper'
require_relative 'spec_helpers'

describe JoinProjectTool do
  let(:user) { create(:user) }
  let(:project) { create(:idea) }

  it 'joins the project' do
    response = call_tool(described_class, { project_id: project.id }, user)

    expect(response.error?).to be(false)
    expect(project.reload.users).to include(user)
  end

  it 'treats re-joining as idempotent success' do
    call_tool(described_class, { project_id: project.id }, user)

    response = nil
    expect do
      response = call_tool(described_class, { project_id: project.id }, user)
    end.not_to(change { project.reload.memberships_count })

    expect(response.error?).to be(false)
    expect(response_text(response)).to match(/already a member/i)
  end

  it 'denies uniformly for guests' do
    expect(call_tool(described_class, { project_id: project.id }, User.new)).to be_denied
  end

  it 'denies uniformly for unknown projects' do
    expect(call_tool(described_class, { project_id: 999_999 }, user)).to be_denied
  end

  it 'returns an error response for finished projects' do
    finished = create(:invention)

    response = call_tool(described_class, { project_id: finished.id }, user)

    expect(response.error?).to be(true)
    expect(finished.reload.users).not_to include(user)
  end
end
