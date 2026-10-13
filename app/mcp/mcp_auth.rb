# Bearer-token authentication for the MCP endpoint.
module McpAuth
  # Returns the live token record for a presented secret, nil when
  # missing/unknown/revoked.
  def self.authenticate_token(raw)
    api_token = ApiToken.authenticate(raw.to_s.strip)
    return nil if api_token.nil?

    api_token.update!(last_used_at: Time.current)
    api_token
  end

  # Returns the token-owning user, nil for missing/unknown/revoked secrets.
  def self.authenticate_bearer(token)
    authenticate_token(token)&.user
  end

  # Effective scope of the presented secret, nil when unauthenticated.
  def self.token_scope(token)
    authenticate_token(token)&.scope
  end
end
