# Bearer-token authentication for the MCP endpoint.
module McpAuth
  # Minimum gap between last_used_at writes; hot clients must not dirty a
  # row on every call.
  TOUCH_INTERVAL = 1.minute

  # Returns the live token record for a presented secret, nil when
  # missing/unknown/revoked.
  def self.authenticate_token(raw)
    api_token = ApiToken.authenticate(raw.to_s.strip)
    return nil if api_token.nil?

    touch_last_used(api_token)
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

  # Refresh last_used_at at most once per TOUCH_INTERVAL, bypassing
  # validations, callbacks and updated_at churn.
  def self.touch_last_used(api_token)
    stamp = api_token.last_used_at
    return if stamp.present? && stamp > TOUCH_INTERVAL.ago

    api_token.update_column(:last_used_at, Time.current)
  end
end
