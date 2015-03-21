class SearchController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :result ]
  def result
    @projects = Project.search params[:q], star: true
    @users = User.search params[:q], star: true
  end
end
