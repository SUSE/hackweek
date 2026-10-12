# Bearer-token authentication for the MCP endpoint.
#
# TODO: verify ApiToken here (later lane). Every token is rejected for now,
# so bearer requests fall back to the guest user.
module McpAuth
  def self.authenticate_bearer(_token)
    nil
  end
end
