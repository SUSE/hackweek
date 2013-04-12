class UserInterest < ActiveRecord::Base
  attr_accessible :keyword_id, :user_id
  
  belongs_to :user
  belongs_to :keyword
end
