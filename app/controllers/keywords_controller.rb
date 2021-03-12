class KeywordsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :load_keyword, only: [:show]


  def index
    respond_to do |format|
      format.json do
        render json: { keywords: Keyword.find_keyword(params[:q]) }
      end
    end
  end

  def show
    @projects = Project.by_episode(@episode).by_keyword(@keyword).includes(:originator, :users, :kudos).page(params[:page]).per(params[:page_size])
    render 'projects/index'
  end

  private

  def load_keyword
    @keyword = Keyword.find_by(name: params[:name]) if params[:name]
  end
end
