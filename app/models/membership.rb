class Membership < ActiveRecord::Base
  belongs_to :project, counter_cache: true
  belongs_to :user

end
