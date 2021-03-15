class SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:result]
  def result
    # First search in morphology mode, if fails — retry in wildcard mode
    search_query = ThinkingSphinx::Query.escape(params[:q])
    if @episode.to_param == 'all'
      @projects = Project.search search_query
      @projects = Project.search search_query, star: true if @projects.empty?
    else
      @projects = Project.search search_query, with: { episode_ids: params[:episode].to_i }
      if @projects.empty?
        @projects = Project.search search_query, with: { episode_ids: params[:episode].to_i }, star: true
      end
    end

    @users = User.search search_query
    @users = User.search search_query, star: true if @users.empty?
  end

  def keyword
    respond_to do |format|
      format.json do
        render json: { keywords: Keyword.find_keyword(params[:q]) }
      end
    end
  end
end
