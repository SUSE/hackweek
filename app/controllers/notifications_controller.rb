class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @notifications = Notification.logged_in(current_user)
  end
end
