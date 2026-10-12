require_relative '../mcp/server_info_tool'
require_relative '../mcp/mcp_auth'

# JSON-RPC endpoint for the Model Context Protocol (Streamable HTTP, stateless).
class McpController < ApplicationController
  skip_before_action :store_location, :load_news, :set_episode, :load_notifications
  skip_before_action :authenticate_user!
  skip_forgery_protection only: [:create]

  def create
    return head :unsupported_media_type unless request.media_type == 'application/json'

    server = MCP::Server.new(
      name: 'hackweek',
      version: '1.0.0',
      tools: [ServerInfoTool],
      server_context: { user: mcp_user }
    )
    transport_options = { stateless: true, serve_subscriptions_listen: false }
    # DNS-rebinding protection only allows loopback Hosts by default, which
    # rejects the test suite's dummy host; widen it in test env only.
    transport_options[:allowed_hosts] = [request.host] if Rails.env.test?
    transport = MCP::Server::Transports::StreamableHTTPTransport.new(server, **transport_options)
    status, headers, body = transport.handle_request(request)

    render(json: body.first, status:, headers:)
  end

  private

  # Devise session or Bearer token, falling back to a guest (unpersisted) user.
  def mcp_user
    return current_user if user_signed_in?

    token = bearer_token
    authed = McpAuth.authenticate_bearer(token) if token
    authed || User.new
  end

  def bearer_token
    match = request.headers['Authorization'].to_s.match(/\ABearer\s+(.+)\z/i)
    match && match[1]
  end
end
