class UsersController < ApplicationController
  
  skip_before_filter :login_required, :only => [ :show ]
  
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
    current_user.add_keyword! keyword_params
    
    redirect_to :action => "me", notice: "Keyword '#{params[:new_keyword]}' added."
  end

  def user_params
    params.require(:user).permit(:email, :name, :uid)
  end

  def keyword_params
    params.require(:new_keyword)
  end

end
