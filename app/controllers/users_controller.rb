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
end
