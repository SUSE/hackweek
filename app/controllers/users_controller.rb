class UsersController < ApplicationController
  before_action :find_user_by_id
  before_action :redirect_to_slug, only: [:show]
  load_and_authorize_resource find_by: :name
  before_action :set_updates, except: :index

  skip_before_action :authenticate_user!, only: %i[show originated likes opportunities]
  skip_before_action :verify_authenticity_token, only: %i[add_keyword delete_keyword]

  def index
    @users = User.all.page(params[:page]).per(params[:page_size])
    respond_to do |format|
      format.html { render }
      format.js
    end
  end

  def edit
    @api_tokens = owner_tokens
  end

  def update
    @user.update(params['user'])
    redirect_to user_path(@user)
  end

  def show
    @projects = @user.projects.by_episode(Episode.active)
  end

  def originated
    @projects = @user.originated_projects
    render :show
  end

  def likes
    @projects = @user.favourites
    render :show
  end

  def opportunities
    @projects = @user.recommended_projects(@episode)
    render :show
  end

  def add_keyword
    keywords = keyword_params.split(',')
    keywords.each do |word|
      logger.debug "Adding keyword \"#{word}\" from user #{@user.id}"
      current_user.add_keyword! word
    end
    redirect_to @user, notice: "Keyword '#{params[:keyword]}' added."
  end

  def delete_keyword
    keywords = keyword_params.split(',')
    keywords.each do |word|
      logger.debug "Deleting keyword \"#{word}\" to user #{@user.id}"
      current_user.remove_keyword! word
    end
    redirect_to @user, notice: "Keyword '#{params[:keyword]}' removed."
  end

  def tokens
    @api_tokens = owner_tokens
  end

  def create_token
    @token = ApiToken.new(user: @user, name: params[:name], scope: params[:scope])
    @api_tokens = owner_tokens
    if @token.save
      @raw_token = @token.raw_token
      render :tokens
    else
      render :tokens, status: :unprocessable_content
    end
  end

  def revoke_token
    token = ApiToken.find_by!(id: params[:token_id], user_id: @user.id)
    token.revoke!
    redirect_back_or_to tokens_user_path(@user), notice: "Token '#{token.name}' revoked."
  end

  private

  def owner_tokens
    ApiToken.where(user: @user).order(created_at: :desc)
  end

  def user_params
    params.require(:user).permit(:location, :hide_email)
  end

  def keyword_params
    params.require(:keyword)
  end

  def find_user_by_id
    @user = User.find_by(id: params[:id])
  end

  def set_updates
    @updates = @user.updates.page(1)
    @last_page = @user.updates.page(1).last_page? || @user.updates.empty?
  end

  def redirect_to_slug
    redirect_to @user if @user
  end
end
