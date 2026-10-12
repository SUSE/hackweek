# Bearer secrets for the MCP endpoint. Only the SHA256 digest hits the
# database; the raw token is exposed once via #raw_token right after mint.
class ApiToken < ApplicationRecord
  belongs_to :user

  SCOPES = %w[read write].freeze

  validates :name, presence: true
  validates :scope, presence: true, inclusion: { in: SCOPES }
  validates :token_digest, presence: true, uniqueness: true

  attr_reader :raw_token

  before_validation :mint_secret, on: :create

  def self.digest(raw)
    Digest::SHA256.hexdigest(raw.to_s)
  end

  # Returns the live record for a presented secret, nil when unknown/revoked.
  def self.authenticate(raw)
    return nil if raw.blank?

    expected = digest(raw)
    candidate = find_by(token_digest: expected)
    return nil if candidate.nil? || candidate.revoked?
    return nil unless ActiveSupport::SecurityUtils.secure_compare(candidate.token_digest, expected)

    candidate
  end

  def revoked?
    revoked_at.present?
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  def write?
    scope == 'write'
  end

  private

  def mint_secret
    return if token_digest.present?

    @raw_token = SecureRandom.hex(32)
    self.token_digest = self.class.digest(@raw_token)
  end
end
