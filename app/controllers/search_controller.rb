class SearchController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :result ]
  def result
    # First search in morphology mode, if fails — retry in wildcard mode
    @projects = Project.search params[:q]
    @projects = Project.search params[:q], star: true if @projects.empty?

    @users = User.search params[:q]
    @users = User.search params[:q], star: true if @users.empty?
  end
end
