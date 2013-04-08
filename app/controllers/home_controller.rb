class HomeController < ApplicationController
  def index
  end
  
  def awards
    render :layout => "home_single"
  end

  def howto
    render :layout => "home_single"
  end
end
