class Project < ActiveRecord::Base
  attr_accessible :description, :title, :originator
  validates :title, :presence => true
  validates :description, :presence => true
  validates :originator_id, :presence => true
  
  belongs_to :originator, :class_name => User

  has_many :users, :through => :memberships
  has_many :kudos, :through => :likes, :source => :user
  
  has_many :memberships
  has_many :likes
  has_many :updates

  has_many :comments, :as => :commentable

  after_create :create_initial_update
  
  def create_initial_update
    Update.create!(:author => self.originator,
                   :text => "#{self.originator.name} originated this idea.",
                   :project => self)
  end
  
  def join! user
    self.users << user
    self.save!

    Update.create!(:author => user,
                   :text => "#{user.name} joined this project.",
                   :project => self)
  end
  
  def leave! user
    self.users -= [ user ]
    self.save!

    Update.create!(:author => user,
                   :text => "#{user.name} left this project.",
                   :project => self)
  end
  
  def like! user
    self.kudos << user
    self.save!

    Update.create!(:author => user,
                   :text => "#{user.name} likes this project.",
                   :project => self)
  end
  
  def dislike! user
    self.kudos -= [ user ]
    self.save!

    Update.create!(:author => user,
                   :text => "#{user.name} dislikes this project.",
                   :project => self)
  end
end
