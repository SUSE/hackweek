class NotificationMailer < ApplicationMailer
  default from: 'hackweek@suse.com'

  def notifier(user, notification)
    @user = user
    @notification = notification

    mail to: user.email, subject: 'Hackweek: New Notifications' do |format|
      format.text
    end
  end
end
