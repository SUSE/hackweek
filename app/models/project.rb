class Project < ActiveRecord::Base
  attr_accessible :description, :title
  validates :title, :presence => true
  validates :originator_id, :presence => true
  
  belongs_to :originator, :class_name => User
  
  has_many :updates

  after_create :create_initial_update
  
  def create_initial_update
    self.updates.create(:author => self.originator,
                        :text => "#{self.originator.name} originated this idea.")
  end
end
