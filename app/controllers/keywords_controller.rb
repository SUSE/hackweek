class KeywordsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :load_keyword, only: %i[show edit update]

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

  # GET /keywords/1/edit
  def edit; end

  # PATCH/PUT /keywords/javascript
  def update
    if @keyword.update(keyword_params)
      redirect_to(keyword_url(@episode, name: @keyword.name), notice: 'Keyword was successfully updated.')
    else
      render :edit
    end
  end

  private

  def load_keyword
    @keyword = Keyword.find_by!(name: params[:name])
  end

  # Only allow a trusted parameter "white list" through.
  def keyword_params
    params.require(:keyword).permit(:description, :avatar)
  end
end
