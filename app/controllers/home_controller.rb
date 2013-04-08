class HomeController < ApplicationController
  
  skip_before_filter :login_required
  
  layout "home"

  def index
  end
  
  def awards
    render :layout => "application"
  end

  def howto
    render :layout => "application"
  end
end
