class HomeController < ApplicationController
  
  skip_before_filter :login_required
  
  def index
  end
  
  def awards
    render :layout => "home_single"
  end

  def howto
    render :layout => "home_single"
  end
end
