require 'rails_helper'

describe NotificationMailer do
  describe 'notifier' do
    let(:user) {create :user}
    let(:notification) {create :notification}

    let(:mail) { NotificationMailer.notifier(user, notification) }

    it 'renders the subject' do
      expect(mail.subject).to eql('Hackweek: New Notifications')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['hackweek@suse.com'])
    end
  end
end
