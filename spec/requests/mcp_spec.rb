require 'rails_helper'

RSpec.describe 'MCP endpoint', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:json_headers) do
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json, text/event-stream' }
  end

  def mcp_post(payload, headers = json_headers)
    post '/mcp', params: payload.to_json, headers: headers
  end

  def bearer_headers(raw)
    json_headers.merge('Authorization' => "Bearer #{raw}")
  end

  def result_body
    response.parsed_body['result']
  end

  def tool_text
    result_body['content'].map { |block| block['text'] }.join
  end

  def denied_result?
    result_body['isError'] == true && tool_text == 'Not accessible through this server'
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

  it 'rejects non-JSON posts with 415' do
    post '/mcp', params: 'hello', headers: { 'CONTENT_TYPE' => 'text/plain' }

    expect(response).to have_http_status(:unsupported_media_type)
  end

  context 'with bearer tokens' do
    let(:user) { create(:user) }
    let(:read_token) { ApiToken.create!(user: user, name: 'read', scope: 'read') }
    let(:write_token) { ApiToken.create!(user: user, name: 'write', scope: 'write') }
    let(:read_raw) { read_token.raw_token }
    let(:write_raw) { write_token.raw_token }

    def tool_call(name, args, raw, id: 100)
      mcp_post({ jsonrpc: '2.0', id: id, method: 'tools/call',
                 params: { name: name, arguments: args } }, bearer_headers(raw))
    end

    def expect_no_token_leak(raw)
      expect(response.body).not_to include(raw)
      expect(response.body).not_to include(ApiToken.digest(raw))
    end

    it 'lists all eight wired tools' do
      mcp_post({ jsonrpc: '2.0', id: 5, method: 'tools/list', params: {} },
               bearer_headers(read_raw))

      expect(response).to have_http_status(:ok)
      names = result_body['tools'].pluck('name')
      expect(names).to contain_exactly('server_info', 'list_projects', 'get_project',
                                       'search_projects', 'list_episodes', 'my_projects',
                                       'create_update', 'join_project')
      expect_no_token_leak(read_raw)
    end

    it 'calls server_info as the token owner and records usage' do
      tool_call('server_info', {}, read_raw)

      expect(response).to have_http_status(:ok)
      expect(tool_text).to include(user.name).and include(user.email)
      expect(read_token.reload.last_used_at).to be_present
      expect_no_token_leak(read_raw)
    end

    it 'lists projects' do
      project = create(:idea)

      tool_call('list_projects', { episode: 'all' }, read_raw)

      expect(response).to have_http_status(:ok)
      expect(response_payload.pluck('id')).to include(project.id)
      expect_no_token_leak(read_raw)
    end

    it 'shows a project' do
      project = create(:idea, originator: user)

      tool_call('get_project', { id: project.url }, read_raw)

      expect(response).to have_http_status(:ok)
      expect(response_payload).to include('title' => project.title)
      expect_no_token_leak(read_raw)
    end

    it 'searches projects' do
      project = create(:idea, title: 'Ferret sanctuary rota')

      tool_call('search_projects', { query: 'ferret' }, read_raw)

      expect(response).to have_http_status(:ok)
      expect(response_payload.pluck('id')).to include(project.id)
      expect_no_token_leak(read_raw)
    end

    it 'lists episodes' do
      create(:episode, name: 'Ep999')

      tool_call('list_episodes', {}, read_raw)

      expect(response).to have_http_status(:ok)
      expect(response_payload.pluck('title')).to include('Ep999')
      expect_no_token_leak(read_raw)
    end

    it "returns the token owner's projects, proving the real user is carried" do
      originated = create(:idea, originator: user)
      create(:idea)

      tool_call('my_projects', {}, read_raw)

      expect(response).to have_http_status(:ok)
      by_id = response_payload.index_by { |entry| entry['id'] }
      expect(by_id.keys).to contain_exactly(originated.id)
      expect(by_id[originated.id]).to include('title' => originated.title, 'role' => 'originator')
      expect_no_token_leak(read_raw)
    end

    it 'creates an update with a write token' do
      project = create(:idea, originator: user)

      expect do
        tool_call('create_update', { project_id: project.id, text: 'bearer progress' }, write_raw)
      end.to change(Update, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(tool_text).to include("project '#{project.title}'")
      expect_no_token_leak(write_raw)
    end

    it 'joins a project with a write token' do
      project = create(:idea)

      tool_call('join_project', { project_id: project.id }, write_raw)

      expect(response).to have_http_status(:ok)
      expect(project.reload.users).to include(user)
      expect_no_token_leak(write_raw)
    end

    it 'denies write tools to read-scoped tokens exactly like guests' do
      project = create(:idea, originator: user)
      payload = { jsonrpc: '2.0', id: 42, method: 'tools/call',
                  params: { name: 'create_update',
                            arguments: { project_id: project.id, text: 'hijack' } } }

      mcp_post(payload)
      guest_result = result_body

      mcp_post(payload, bearer_headers(read_raw))

      expect(response).to have_http_status(:ok)
      expect(denied_result?).to be(true)
      expect(result_body).to eq(guest_result)
      expect_no_token_leak(read_raw)
    end

    it 'creates no update for read-scoped write calls' do
      project = create(:idea, originator: user)
      payload = { jsonrpc: '2.0', id: 43, method: 'tools/call',
                  params: { name: 'create_update',
                            arguments: { project_id: project.id, text: 'hijack' } } }

      expect do
        mcp_post(payload, bearer_headers(read_raw))
      end.not_to change(Update, :count)

      expect(denied_result?).to be(true)
    end

    it 'denies joining projects to read-scoped tokens' do
      project = create(:idea)

      tool_call('join_project', { project_id: project.id }, read_raw)

      expect(response).to have_http_status(:ok)
      expect(denied_result?).to be(true)
      expect(project.reload.users).not_to include(user)
      expect_no_token_leak(read_raw)
    end

    it 'treats revoked tokens as guests' do
      raw = read_raw
      read_token.revoke!

      tool_call('server_info', {}, raw)

      expect(response).to have_http_status(:ok)
      expect(tool_text).to include('guest')
      expect(tool_text).not_to include('@')
      expect(read_token.reload.last_used_at).to be_nil
      expect_no_token_leak(raw)
    end

    it 'treats unknown tokens as guests' do
      tool_call('server_info', {}, SecureRandom.hex(32))

      expect(response).to have_http_status(:ok)
      expect(tool_text).to include('guest')
      expect(tool_text).not_to include('@')
    end

    it 'keeps token material out of responses and logs' do
      project = create(:idea, originator: user)
      tool_call('create_update', { project_id: project.id, text: 'quiet' }, write_raw)

      expect(response).to have_http_status(:ok)
      expect_no_token_leak(write_raw)
      log_path = Rails.root.join('log/test.log')
      expect(File.read(log_path, mode: 'r:UTF-8')).not_to include(write_raw) if File.exist?(log_path)
    end
  end
end
