# Bearer-token authentication for the MCP endpoint.
module McpAuth
  # Returns the token-owning user, nil for missing/unknown/revoked secrets.
  def self.authenticate_bearer(token)
    api_token = ApiToken.authenticate(token.to_s.strip)
    return nil if api_token.nil?

    api_token.update!(last_used_at: Time.current)
    api_token.user
  end

  # Effective scope of the presented secret, nil when unauthenticated.
  def self.token_scope(token)
    ApiToken.authenticate(token.to_s.strip)&.scope
  end
end
