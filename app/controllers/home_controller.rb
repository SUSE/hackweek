class HomeController < ApplicationController
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
