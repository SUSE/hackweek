class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = Notification.logged_in(current_user).unread
  end

  def mark_as_read
    @notifications = Notification.logged_in(current_user).unread
    @notifications.update_all(read_at: Time.zone.now)
  end
end
