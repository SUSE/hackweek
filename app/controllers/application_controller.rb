class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  
  protected
  
  def redirect_back_or_default default = "/"
    redirect_to session[:return_to] || default
    session[:return_to] = nil
  end 

  def store_location 
    session[:return_to] = request.fullpath
  end

  def keyword_tokens
    required_parameters :q
    render json: Keyword.find_keyword(params[:q])
  end

end
