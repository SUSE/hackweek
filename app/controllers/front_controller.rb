class FrontController < ApplicationController
  
  skip_before_filter :login_required
  
  layout "front"

  def index
  end
  
  def awards
    render :layout => "application"
  end

  def howto
    render :layout => "application"
  end
end
