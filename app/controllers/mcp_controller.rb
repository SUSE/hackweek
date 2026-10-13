# JSON-RPC endpoint for the Model Context Protocol (Streamable HTTP, stateless).
class McpController < ApplicationController
  skip_before_action :store_location, :load_news, :set_episode, :load_notifications
  skip_before_action :authenticate_user!
  skip_forgery_protection only: [:create], if: -> { mcp_bearer_authenticated? }

  TOOLS = [ServerInfoTool, ListProjectsTool, GetProjectTool, SearchProjectsTool,
           ListEpisodesTool].freeze

  def create
    return head :unsupported_media_type unless request.media_type == 'application/json'

    server = MCP::Server.new(
      name: 'hackweek',
      version: '1.0.0',
      tools: TOOLS,
      server_context: { user: mcp_user, scope: mcp_scope }
    )
    transport_options = { stateless: true, serve_subscriptions_listen: false }
    # DNS-rebinding protection only allows loopback Hosts by default; Rails'
    # own HostAuthorization already rejected unknown hosts before this
    # controller, so trusting the surviving request host is safe in all envs.
    transport_options[:allowed_hosts] = [request.host]
    transport = MCP::Server::Transports::StreamableHTTPTransport.new(server, **transport_options)
    status, headers, body = transport.handle_request(request)

    # JSON-RPC notifications ack with 202 and no body; rendering
    # body.first (nil) would answer `null` instead.
    return head status if body.empty?

    render(json: body.first, status:, headers:)
  end

  private

  # Devise session or Bearer token, falling back to a guest (unpersisted) user.
  # A present Bearer header owns the request: the session is ignored, so a
  # junk secret degrades to guest even with a valid cookie.
  def mcp_user
    return mcp_auth_token.user if mcp_auth_token
    return current_user if bearer_token.nil? && user_signed_in?

    User.new
  end

  # Tokens carry their own scope; the session carries full agency; guests none.
  # Mirrors mcp_user so both derive from the single memoized authentication.
  def mcp_scope
    return mcp_auth_token.scope if mcp_auth_token
    return 'write' if bearer_token.nil? && user_signed_in?

    nil
  end

  # Write tools enforce the write scope themselves with the same uniform
  # denial, so no controller pre-check is needed here.
  def bearer_token
    match = request.headers['Authorization'].to_s.match(/\ABearer\s+(.+)\z/i)
    match && match[1]
  end

  # Skips forgery protection only for requests carrying a real token; a
  # junk Bearer still faces the session CSRF check.
  def mcp_bearer_authenticated?
    mcp_auth_token.present?
  end

  # Single memoized authentication per request (nil-safe: a junk secret
  # authenticates once, then stays nil for the user, scope and write checks).
  def mcp_auth_token
    return @mcp_auth_token if defined?(@mcp_auth_token)

    raw = bearer_token
    @mcp_auth_token = raw ? McpAuth.authenticate_token(raw) : nil
  end
end
