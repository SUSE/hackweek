class NotificationMailer < ApplicationMailer
  default from: 'hackweek@suse.com'

  def notifier(user)
    @user = user

    mail to: user.email, subject: 'Hackweek: New Notifications'
  end
end
