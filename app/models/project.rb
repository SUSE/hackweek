class Project < ActiveRecord::Base
  validates :title, :presence => true
  validates :description, :presence => true
  validates :originator_id, :presence => true
  
  belongs_to :originator, :class_name => User

  has_many :users, :through => :memberships
  has_many :kudos, :through => :likes, :source => :user

  has_many :project_interests
  has_many :keywords, :through => :project_interests
  
  has_many :memberships
  has_many :likes
  has_many :updates

  has_many :comments, :as => :commentable

  after_create :create_initial_update
  
  def create_initial_update
    Update.create!(:author => self.originator,
                   :text => "originated",
                   :project => self)
  end
  
  def join! user
    self.users << user
    self.save!

    Update.create!(:author => user,
                   :text => "joined",
                   :project => self)
  end
  
  def leave! user
    self.users -= [ user ]
    self.save!

    Update.create!(:author => user,
                   :text => "left",
                   :project => self)
  end
  
  def like! user
    self.kudos << user
    self.save!

    Update.create!(:author => user,
                   :text => "liked",
                   :project => self)
  end
  
  def dislike! user
    self.kudos -= [ user ]
    self.save!

    Update.create!(:author => user,
                   :text => "disliked",
                   :project => self)
  end
  
  def add_keyword! name
    name.downcase!
    name.gsub! /\s/, "" 
    keyword = Keyword.find_by_name name
    if !keyword
      keyword = Keyword.create! :name => name
    end
    if !self.keywords.include? keyword
      self.keywords << keyword
      save!
    end
  end
end
