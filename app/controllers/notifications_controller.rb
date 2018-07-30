class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @older_notifications = Notification.logged_in(current_user).order('created_at DESC').page(params[:page])
  end

  def mark_as_read
    @notifications = Notification.logged_in(current_user).unread
    @notifications.update_all(read_at: Time.zone.now)
  end
end
