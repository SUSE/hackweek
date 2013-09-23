class UsersController < ApplicationController
  
  load_and_authorize_resource
  skip_before_filter :authenticate_user!, :only => [ :show ]

  def index
    @users = User.all
  end

  def show      
      @user = User.find_by id: params[:id]
      if not @user
        flash["alert-warning"] = "User not found"
        redirect_to projects_path
      end
  end

  def me
    redirect_to user_path(current_user)
  end
  
  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to :action => "me", notice: 'User profile was successfully updated.'
    else
      render :action => "edit"
    end
  end
  
  def add_keyword
    keywords = keyword_params.split(',')
    keywords.each do |word|
      current_user.add_keyword! word
    end
    redirect_to :action => "me", notice: "Keyword '#{params[:keyword]}' added."
  end

  def delete_keyword
    keywords = keyword_params.split(',')
    keywords.each do |word|
      current_user.remove_keyword! word
    end
    redirect_to :action => "me", notice: "Keyword '#{params[:keyword]}' removed."
  end

  def user_params
    params.require(:user).permit(:email, :name, :uid)
  end

  def keyword_params
    params.require(:keyword)
  end

end
