# JSON-RPC endpoint for the Model Context Protocol (Streamable HTTP, stateless).
class McpController < ApplicationController
  skip_before_action :store_location, :load_news, :set_episode, :load_notifications
  skip_before_action :authenticate_user!
  # Session-only in this stack; Bearer-token clients cannot complete the
  # browser login, so token authentication arrives with the token stack.
  skip_forgery_protection only: [:create]

  TOOLS = [ServerInfoTool, ListProjectsTool, GetProjectTool, SearchProjectsTool,
           ListEpisodesTool].freeze

  def create
    return head :unsupported_media_type unless request.media_type == 'application/json'

    user = user_signed_in? ? current_user : User.new
    server = MCP::Server.new(
      name: 'hackweek',
      version: '1.0.0',
      tools: TOOLS,
      server_context: { user: user }
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
end
