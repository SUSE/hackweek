class SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:result]
  def result
    # First search in morphology mode, if fails — retry in wildcard mode
    if @episode.to_param == 'all'
      @projects = Project.search params[:q]
      @projects = Project.search params[:q], star: true if @projects.empty?
    else
      @projects = Project.search params[:q], with: { episode_ids: params[:episode].to_i }
      if @projects.empty?
        @projects = Project.search params[:q], with: { episode_ids: params[:episode].to_i }, star: true
      end
    end

    @users = User.search params[:q]
    @users = User.search params[:q], star: true if @users.empty?
  end
end
