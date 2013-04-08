class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :login_required
  
  def login_required
    if current_user
      return true
    else
      redirect_to :controller=>"/account", :action =>"login"
      return false
    end
  end

  def current_user
    return @current_user if @current_user
    
    user_id = session[:user_id]
    if !user_id
      @current_user = nil
    else
      begin
        @current_user = User.find user_id
      rescue ActiveRecord::RecordNotFound
        @current_user = nil
      end
    end
  end
end
