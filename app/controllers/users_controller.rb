class UsersController < ApplicationController
  
  skip_before_filter :login_required, :only => [ :show ]
  
  def show
    @user = User.find params[:id]
  end

  def me
  end
  
  def edit
  end

  def update
    if @current_user.update_attributes(params[:user])
      redirect_to :action => "me", notice: 'User profile was successfully updated.'
    else
      render :action => "edit"
    end
  end
  
  def add_keyword
    current_user.add_keyword! params[:new_keyword]
    
    redirect_to :action => "me", notice: "Keyword '#{params[:new_keyword]}' added."
  end

  def user_params
    params.require(:user).permit(:email, :name, :uid)
  end
  def user_interest_params
    params.require(:user_interest).permit(:keyword_id, :user_id)
  end
end
