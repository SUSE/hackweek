class SearchController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [ :result ]
  def result
    search_result = Project.search { fulltext params[:search_string] }
    @projects = search_result.results
    search_result = User.search { fulltext params[:search_string] }
    @users = search_result.results
  end
end
