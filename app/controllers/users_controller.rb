class UsersController < ApplicationController

  before_action :find_user_by_id
  before_action :redirect_to_slug, only: [:show]
  load_and_authorize_resource find_by: :name

  skip_before_action :authenticate_user!, :only => [ :index, :show ]
  skip_before_action :verify_authenticity_token, :only => [:add_keyword, :delete_keyword ]

  def index
    @users = User.all
  end

  def edit
  end

  def update
    current_user.update_attributes(params["user"])
    redirect_to user_path(current_user)
  end

  def show
  end

  def me
    redirect_to user_path(current_user)
  end

  def add_keyword
    keywords = keyword_params.split(',')
    keywords.each do |word|
      logger.debug "Adding keyword \"#{word}\" from user #{@user.id}"
      current_user.add_keyword! word
    end
    redirect_to :action => "me", notice: "Keyword '#{params[:keyword]}' added."
  end

  def delete_keyword
    keywords = keyword_params.split(',')
    keywords.each do |word|
      logger.debug "Deleting keyword \"#{word}\" to user #{@user.id}"
      current_user.remove_keyword! word
    end
    redirect_to :action => "me", notice: "Keyword '#{params[:keyword]}' removed."
  end

  private
    def user_params
      params.require(:user).permit(:location)
    end

    def keyword_params
      params.require(:keyword)
    end

    def find_user_by_id
      @user = User.find_by(id: params[:id])
    end

    def redirect_to_slug
      redirect_to @user if @user
    end
end
