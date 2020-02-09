class UpdatesController < ApplicationController
  skip_before_action :load_news
  skip_before_action :set_episode
  skip_before_action :load_notifications
  before_action :set_updates

  def index
    @next_page = params[:page].to_i + 1
    @last_page = @updates.page(params[:page]).last_page?
  end

  private

  def set_updates
    @updates = []
    @updates = current_user.updates.page(params[:page]) unless params[:project_id]
    return unless params[:project_id]

    @project = Project.find(params[:project_id])
    @updates = @project.updates.page(params[:page])
  end
end
