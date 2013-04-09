class Project < ActiveRecord::Base
  attr_accessible :description, :title, :originator
  validates :title, :presence => true
  validates :originator_id, :presence => true
  
  belongs_to :originator, :class_name => User
  
  has_many :updates

  has_many :memberships
  has_many :users, :through => :memberships
  
  after_create :create_initial_update
  
  def create_initial_update
    Update.create(:author => self.originator,
                  :text => "#{self.originator.name} originated this idea.",
                  :project => self)
  end
  
end
