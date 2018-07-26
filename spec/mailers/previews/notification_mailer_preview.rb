class NotificationMailerPreview < ActionMailer::Preview

  def notifier
    NotificationMailer.notifier(User.first)
  end
end
