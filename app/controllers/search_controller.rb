class SearchController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :result ]
  def result
    # First search in morphology mode, if fails — retry in wildcard mode
    episode = params[:episode]

    if episode != "all"
      @projects = Project.search params[:q],conditions: {episode_names: episode}
      @projects = Project.search params[:q],conditions: {episode_names: episode}, star: true if @projects.empty?
    else
      @projects = Project.search params[:q]
      @projects = Project.search params[:q], star: true if @projects.empty?
    end

    @users = User.search params[:q]
    @users = User.search params[:q], star: true if @users.empty?
  end
end
