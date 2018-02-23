class Membership < ActiveRecord::Base
  belongs_to :project, counter_cache: true
  belongs_to :user

  def update_location(location)

    self.location = location == "None" ? ' ' : location
    self.save
  end
end
