class Projects::ProjectFollowsController < ApplicationController
  load_and_authorize_resource :project, find_by: :url

  def index
    @users = @project.project_followers
  end

  def create
    current_user.project_followings= current_user.project_followings | [@project]
    flash.now[:notice] = "You are now watching #{@project.title}"
    render 'follow_toggle'
  end

  def destroy
    current_user.project_followings.delete @project
    flash.now[:notice] =  "You have stopped watching #{@project.title}"
    render 'follow_toggle'
  end
end
