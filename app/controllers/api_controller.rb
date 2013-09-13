class ApiController < ApplicationController

  skip_before_filter :authenticate_user! 
  
  def import
    json = request.body.read
    begin
      ProjectImporter.import json
      render :text => "ok\n"
    rescue StandardError => err
      render :text => "Error: #{err}\n", :status => 500
    end    
  end
  
end
