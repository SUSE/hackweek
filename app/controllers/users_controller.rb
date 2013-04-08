class UsersController < ApplicationController
  
  skip_before_filter :login_required, :only => [ :show ]
  
  def show
    @user = User.find params[:id]
  end

  def me
  end
end
