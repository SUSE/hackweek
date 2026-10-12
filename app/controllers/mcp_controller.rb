# JSON-RPC endpoint for the Model Context Protocol (Streamable HTTP, stateless).
class McpController < ApplicationController
  skip_before_action :store_location, :load_news, :set_episode, :load_notifications
  skip_before_action :authenticate_user!
  skip_forgery_protection only: [:create], if: -> { bearer_token.present? }

  TOOLS = [ServerInfoTool, ListProjectsTool, GetProjectTool, SearchProjectsTool,
           ListEpisodesTool, MyProjectsTool, CreateUpdateTool, JoinProjectTool].freeze
  WRITE_TOOLS = %w[create_update join_project].freeze
  DENIED_MESSAGE = 'Not accessible through this server'.freeze

  def create
    return head :unsupported_media_type unless request.media_type == 'application/json'
    return render_write_denied if write_denied?

    server = MCP::Server.new(
      name: 'hackweek',
      version: '1.0.0',
      tools: TOOLS,
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

  # Write tools need a write-scoped token; the session carries full agency.
  # Denied here so read-scoped callers get the same uniform denial as guests.
  def write_denied?
    return false if user_signed_in?
    return false unless params[:method] == 'tools/call'

    inner = params[:params]
    return false unless inner.is_a?(Hash) || inner.is_a?(ActionController::Parameters)
    return false unless WRITE_TOOLS.include?(inner[:name])

    McpAuth.token_scope(bearer_token) != 'write'
  end

  def render_write_denied
    render json: {
      jsonrpc: '2.0',
      id: params[:id],
      result: { content: [{ type: 'text', text: DENIED_MESSAGE }], isError: true }
    }
  end

  def bearer_token
    match = request.headers['Authorization'].to_s.match(/\ABearer\s+(.+)\z/i)
    match && match[1]
  end
end
