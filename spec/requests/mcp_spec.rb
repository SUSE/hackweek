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

  it 'acks JSON-RPC notifications with a bare 202' do
    mcp_post({ jsonrpc: '2.0', method: 'notifications/initialized', params: {} })

    expect(response).to have_http_status(:accepted)
    expect(response.body).to be_empty
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

    it 'authenticates the bearer only once per request' do
      allow(ApiToken).to receive(:authenticate).and_call_original

      tool_call('server_info', {}, read_raw)

      expect(response).to have_http_status(:ok)
      expect(ApiToken).to have_received(:authenticate).once
    end

    it 'ignores the session when a bearer is present, treating junk as guest' do
      other = create(:user)
      sign_in other
      mcp_post({ jsonrpc: '2.0', id: 101, method: 'tools/call',
                 params: { name: 'server_info', arguments: {} } },
               bearer_headers('junk-secret'))

      expect(response).to have_http_status(:ok)
      expect(tool_text).to include('guest')
      expect(tool_text).not_to include(other.email)
    end

    it 'acts as the token owner when session and bearer disagree' do
      other = create(:user)
      sign_in other

      tool_call('server_info', {}, read_raw)

      expect(response).to have_http_status(:ok)
      expect(tool_text).to include(user.email)
      expect(tool_text).not_to include(other.email)
    end

    context 'with forgery protection enabled' do
      around do |example|
        previous = ActionController::Base.allow_forgery_protection
        ActionController::Base.allow_forgery_protection = true
        example.run
        ActionController::Base.allow_forgery_protection = previous
      end

      it 'skips forgery protection for a real bearer' do
        tool_call('server_info', {}, read_raw)

        expect(response).to have_http_status(:ok)
        expect(tool_text).to include(user.email)
      end

      it 'nulls the session for a junk bearer, denying as guest' do
        other = create(:user)
        sign_in other
        payload = { jsonrpc: '2.0', id: 103, method: 'tools/call',
                    params: { name: 'server_info', arguments: {} } }

        mcp_post(payload, bearer_headers('junk-secret'))

        expect(response).to have_http_status(:ok)
        expect(tool_text).to include('guest')
        expect(tool_text).not_to include(other.email)
      end
    end

    it 'leaves last_used_at alone within a minute' do
      tool_call('server_info', {}, read_raw)
      read_token.update_column(:last_used_at, 30.seconds.ago) # rubocop:disable Rails/SkipsModelValidations
      read_token.update_column(:updated_at, 1.hour.ago) # rubocop:disable Rails/SkipsModelValidations
      fresh_stamp = read_token.reload.last_used_at
      old_updated = read_token.updated_at

      tool_call('server_info', {}, read_raw)

      expect(response).to have_http_status(:ok)
      expect(read_token.reload.last_used_at).to eq(fresh_stamp)
      expect(read_token.reload.updated_at).to eq(old_updated)
    end

    it 'refreshes a stale last_used_at' do
      tool_call('server_info', {}, read_raw)
      fresh_stamp = read_token.reload.last_used_at
      read_token.update_column(:last_used_at, 2.minutes.ago) # rubocop:disable Rails/SkipsModelValidations

      tool_call('server_info', {}, read_raw)

      expect(response).to have_http_status(:ok)
      expect(read_token.reload.last_used_at).to be > fresh_stamp
    end

    it 'lists the five wired read tools' do
      mcp_post({ jsonrpc: '2.0', id: 5, method: 'tools/list', params: {} },
               bearer_headers(read_raw))

      expect(response).to have_http_status(:ok)
      names = result_body['tools'].pluck('name')
      expect(names).to contain_exactly('server_info', 'list_projects', 'get_project',
                                       'search_projects', 'list_episodes')
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
      tool_call('list_projects', { episode: 'all' }, write_raw)

      expect(response).to have_http_status(:ok)
      expect_no_token_leak(write_raw)
      log_path = Rails.root.join('log/test.log')
      expect(File.read(log_path, mode: 'r:UTF-8')).not_to include(write_raw) if File.exist?(log_path)
    end
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

  it 'throttles abusive /mcp traffic' do
    store = Rack::Attack.cache.store
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.throttle('mcp/ip-spec', limit: 3, period: 1.minute) { |req| req.ip if req.path == '/mcp' }
    payload = { jsonrpc: '2.0', id: 200, method: 'initialize',
                params: { protocolVersion: '2025-03-26', capabilities: {},
                          clientInfo: { name: 'spec', version: '0.1' } } }

    3.times { mcp_post(payload) }
    expect(response).to have_http_status(:ok)
    mcp_post(payload)

    expect(response).to have_http_status(:too_many_requests)
  ensure
    Rack::Attack.throttles.delete('mcp/ip-spec')
    Rack::Attack.cache.store = store
  end
end
