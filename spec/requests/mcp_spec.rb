require 'rails_helper'

RSpec.describe 'MCP endpoint', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:json_headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json, text/event-stream' }
  end

  def mcp_post(payload)
    post '/mcp', params: payload.to_json, headers: json_headers
  end

  def result_body
    response.parsed_body['result']
  end

  def tool_text
    result_body['content'].map { |block| block['text'] }.join
  end

  it 'answers the initialize handshake' do
    mcp_post({ jsonrpc: '2.0', id: 1, method: 'initialize',
               params: { protocolVersion: '2025-03-26', capabilities: {},
                         clientInfo: { name: 'spec', version: '0.1' } } })

    expect(response).to have_http_status(:ok)
    expect(result_body['serverInfo']['name']).to eq('hackweek')
  end

  it 'lists tools including server_info' do
    mcp_post({ jsonrpc: '2.0', id: 2, method: 'tools/list', params: {} })

    expect(response).to have_http_status(:ok)
    names = result_body['tools'].pluck('name')
    expect(names).to include('server_info')
  end

  it 'calls server_info for a signed-in user' do
    user = create(:user)
    sign_in user
    mcp_post({ jsonrpc: '2.0', id: 3, method: 'tools/call',
               params: { name: 'server_info', arguments: {} } })

    expect(response).to have_http_status(:ok)
    expect(tool_text).to include(user.name).and include(user.email)
    expect(tool_text).to include('Active episode:')
  end

  it 'reports the active episode title' do
    episode = build(:episode, name: 'Hackweek 99')
    allow(Episode).to receive(:active).and_return(episode)
    text = ServerInfoTool.call(server_context: { user: User.new }).content.first[:text]

    expect(text).to include('Hackweek 99')
  end

  it 'answers guests without leaking any email' do
    create(:user, email: 'someone@example.com')
    mcp_post({ jsonrpc: '2.0', id: 4, method: 'tools/call',
               params: { name: 'server_info', arguments: {} } })

    expect(response).to have_http_status(:ok)
    expect(tool_text).to include('guest')
    expect(tool_text).not_to include('@')
  end

  it 'rejects non-JSON posts with 415' do
    post '/mcp', params: 'hello', headers: { 'CONTENT_TYPE' => 'text/plain' }

    expect(response).to have_http_status(:unsupported_media_type)
  end
end
