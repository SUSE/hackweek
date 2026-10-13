require 'rails_helper'

describe ApiToken do
  let(:user) { create(:user) }

  it 'belongs to a user and defaults to read scope' do
    token = described_class.create!(user: user, name: 'spec')

    expect(token.scope).to eq('read')
    expect(token.user).to eq(user)
  end

  it 'requires a name and a known scope' do
    expect(described_class.new(user: user, name: nil).valid?).to be(false)
    expect(described_class.new(user: user, name: 'spec', scope: 'admin').valid?).to be(false)
  end

  it 'shows the raw secret once and stores only its digest' do
    token = described_class.create!(user: user, name: 'spec', scope: 'write')
    raw = token.raw_token

    expect(raw).to be_present
    expect(token.token_digest).to eq(described_class.digest(raw))
    expect(token.token_digest).not_to eq(raw)
    expect(described_class.find(token.id).raw_token).to be_nil
  end

  it 'never persists the raw secret' do
    token = described_class.create!(user: user, name: 'spec')
    raw = token.raw_token
    stored = ActiveRecord::Base.connection.select_all('SELECT * FROM api_tokens').to_a

    expect(stored.flat_map(&:values)).not_to include(raw)
  end

  it 'authenticates a live token' do
    token = described_class.create!(user: user, name: 'spec')
    found = described_class.authenticate(token.raw_token)

    expect(found).to eq(token)
  end

  it 'rejects unknown secrets' do
    described_class.create!(user: user, name: 'spec')

    expect(described_class.authenticate('no-such-token')).to be_nil
    expect(described_class.authenticate(nil)).to be_nil
    expect(described_class.authenticate('')).to be_nil
  end

  it 'rejects revoked tokens' do
    token = described_class.create!(user: user, name: 'spec')
    raw = token.raw_token
    token.revoke!

    expect(token.revoked?).to be(true)
    expect(described_class.authenticate(raw)).to be_nil
  end

  it 'compares digests in constant time' do
    token = described_class.create!(user: user, name: 'spec')
    raw = token.raw_token
    allow(ActiveSupport::SecurityUtils).to receive(:secure_compare).and_call_original

    described_class.authenticate(raw)

    expect(ActiveSupport::SecurityUtils).to have_received(:secure_compare)
  end
end
