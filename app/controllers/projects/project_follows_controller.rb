class Projects::ProjectFollowsController < ApplicationController
  before_action :get_project
  before_action :get_episode

  def create
    return redirect_to project_path(@episode, @project) if current_user.project_followings.include?(@project)
    current_user.project_followings << @project
    redirect_to project_path(@episode, @project), notice: "You are now watching #{@project.title}"
  end

  def destroy
    current_user.project_followings.delete @project
    redirect_to project_path(@episode, @project), notice: "You have stopped watching #{@project.title}"
  end

  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end

  def get_episode
    @episode = Episode.find(params[:episode_id]) if params[:episode_id]
  end
end
