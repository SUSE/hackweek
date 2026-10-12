class ServerInfoTool < MCP::Tool
  tool_name 'server_info'
  description 'Returns basic information about the Hackweek MCP server and the calling user.'
  input_schema(properties: {}, required: [])
  annotations(read_only_hint: true, destructive_hint: false, idempotent_hint: true, open_world_hint: false)

  def self.call(server_context:)
    # The SDK wraps our { user: } hash in MCP::ServerContext; [:user] reads through on both.
    user = server_context[:user]
    user = User.new unless user.is_a?(User)

    signed_in = user.persisted?
    payload = {
      user: signed_in ? user.name : 'guest',
      admin: signed_in ? user.role?('admin') : false,
      organizer: signed_in ? user.role?('organizer') : false,
      episode: Episode.active&.name,
      tools: McpController::TOOLS.size
    }
    # Guest responses must stay free of any email address.
    payload[:email] = user.email if signed_in

    MCP::Tool::Response.new([{ type: 'text', text: JSON.generate(payload) }])
  end
end
