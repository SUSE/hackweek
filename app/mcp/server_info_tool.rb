# Read-only introspection for the Hackweek MCP server. Never returns secrets,
# only the calling user's own name/email plus public server facts.
class ServerInfoTool < MCP::Tool
  tool_name 'server_info'
  description 'Returns basic information about the Hackweek MCP server and the calling user.'
  annotations(read_only_hint: true, destructive_hint: false, idempotent_hint: true, open_world_hint: false)

  def self.call(server_context:)
    # The SDK wraps our { user: } hash in MCP::ServerContext; [:user] reads through on both.
    user = server_context[:user]
    user = User.new unless user.is_a?(User)

    signed_in = user.persisted?
    lines = ['Hackweek MCP server', "User: #{signed_in ? user.name : 'guest'}"]
    # Guest responses must stay free of any email address.
    lines << "Email: #{user.email}" if signed_in
    lines << "Admin: #{signed_in && user.role?('admin')}"
    lines << "Organizer: #{signed_in && user.role?('organizer')}"
    lines << "Active episode: #{Episode.active&.name || 'none'}"
    # The server owns the tool list; count tool files so later tools show up.
    lines << "Tools: #{Rails.root.glob('app/mcp/*_tool.rb').count}"

    MCP::Tool::Response.new([{ type: 'text', text: lines.join("\n") }])
  end
end
