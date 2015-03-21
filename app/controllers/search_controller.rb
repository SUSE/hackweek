class SearchController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :result ]
  def result
    @projects = Project.search params[:q]
    @users = User.search params[:q]
  end
end
