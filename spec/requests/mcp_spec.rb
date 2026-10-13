require 'rails_helper'

RSpec.describe 'MCP endpoint', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:json_headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json, text/event-stream' }
  end

  def mcp_post(payload, headers = json_headers)
    post '/mcp', params: payload.to_json, headers: headers
  end

  def result_body
    response.parsed_body['result']
  end

  def tool_text
    result_body['content'].map { |block| block['text'] }.join
  end

  def response_payload
    JSON.parse(tool_text)
  end

  it 'answers the initialize handshake' do
    mcp_post({ jsonrpc: '2.0', id: 1, method: 'initialize',
               params: { protocolVersion: '2025-03-26', capabilities: {},
                         clientInfo: { name: 'spec', version: '0.1' } } })

    expect(response).to have_http_status(:ok)
    expect(result_body['serverInfo']['name']).to eq('hackweek')
  end

  it 'trusts the request host outside the test env' do
    Rails.application.config.hosts << 'hackweek.opensuse.org'
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
    host! 'hackweek.opensuse.org'
    mcp_post({ jsonrpc: '2.0', id: 1, method: 'initialize',
               params: { protocolVersion: '2025-03-26', capabilities: {},
                         clientInfo: { name: 'spec', version: '0.1' } } })

    expect(response).to have_http_status(:ok)
    expect(result_body['serverInfo']['name']).to eq('hackweek')
  ensure
    Rails.application.config.hosts.delete('hackweek.opensuse.org')
  end

  it 'lists the five read tools' do
    mcp_post({ jsonrpc: '2.0', id: 2, method: 'tools/list', params: {} })

    expect(response).to have_http_status(:ok)
    expect(result_body['tools'].pluck('name')).to contain_exactly(
      'server_info', 'list_projects', 'get_project', 'search_projects', 'list_episodes'
    )
  end

  it 'calls server_info for a signed-in user' do
    user = create(:user)
    sign_in user
    mcp_post({ jsonrpc: '2.0', id: 3, method: 'tools/call',
               params: { name: 'server_info', arguments: {} } })

    expect(response).to have_http_status(:ok)
    payload = response_payload
    expect(payload).to include('user' => user.name, 'email' => user.email)
    expect(payload).to include('admin', 'organizer', 'episode', 'tools')
  end

  it 'reports the active episode title' do
    episode = build(:episode, name: 'Hackweek 99')
    allow(Episode).to receive(:active).and_return(episode)
    text = ServerInfoTool.call(server_context: { user: User.new }).content.first[:text]

    expect(JSON.parse(text)).to include('episode' => 'Hackweek 99')
  end

  it 'answers guests without leaking any email' do
    create(:user, email: 'someone@example.com')
    mcp_post({ jsonrpc: '2.0', id: 4, method: 'tools/call',
               params: { name: 'server_info', arguments: {} } })

    expect(response).to have_http_status(:ok)
    expect(tool_text).to include('guest')
    expect(tool_text).not_to include('@')
  end

  it 'acks JSON-RPC notifications with a bare 202' do
    mcp_post({ jsonrpc: '2.0', method: 'notifications/initialized', params: {} })

    expect(response).to have_http_status(:accepted)
    expect(response.body).to be_empty
  end

  it 'rejects non-JSON posts with 415' do
    post '/mcp', params: 'hello', headers: { 'CONTENT_TYPE' => 'text/plain' }

    expect(response).to have_http_status(:unsupported_media_type)
  end

  it 'returns a JSON-RPC error for missing id, not 500' do
    mcp_post({ jsonrpc: '2.0', id: 99, method: 'tools/call',
               params: { name: 'get_project', arguments: {} } })

    expect(response).to have_http_status(:ok)
    expect(result_body['isError']).to be(true)
  end

  it 'returns a JSON-RPC error for array params, not 500' do
    mcp_post({ jsonrpc: '2.0', id: 100, method: 'tools/call', params: [] })

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body['error']).to be_present
  end
end
