class SearchController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :result ]
  def result
    # First search in morphology mode, if fails — retry in wildcard mode
    
    if params[:episode] == "all"
      @projects = Project.search params[:q]
      @projects = Project.search params[:q], star: true if @projects.empty?
    else
      @episode = Episode.find(params[:episode])
      @projects = Project.search params[:q],conditions: {episode_names: @episode.name}
      @projects = Project.search params[:q],conditions: {episode_names: @episode.name}, star: true if @projects.empty?
    end

    @users = User.search params[:q]
    @users = User.search params[:q], star: true if @users.empty?
  end
end
