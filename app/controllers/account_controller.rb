class AccountController < ApplicationController
  
  skip_before_filter :login_required
  
  def login
  end

  def logout
    clear_login
  end
  
  def callback
    auth_hash = request.env['omniauth.auth']

    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    email = auth_hash[:info][:email]

    session[:user_id] = 1

    flash[:notice] = "Welcome #{name}"
    
    redirect_to :action => "welcome"
  end

  def welcome
  end

  private

  def clear_login
    session[:user_id] = nil
    @current_user = nil
  end
    
end
