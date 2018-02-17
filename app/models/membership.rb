class Membership < ActiveRecord::Base
  belongs_to :project, counter_cache: true
  belongs_to :user

  def update_location(location)
    if location == "None"
      self.location = ""
    else
      self.location = location
    end  
    self.save
  end
end
