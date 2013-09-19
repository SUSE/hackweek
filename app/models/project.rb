class Project < ActiveRecord::Base
  include AASM

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

  aasm do
    state :new, :initial => true
    state :live
    state :done
    state :quashed
    
    event :change_status do
      transitions :from => [:new], :to => :live
      transitions :from => [:live], :to => :done
      transitions :to => :quashed,  :from => [:new]
    end
    event :abandon do 
      transitions :from => [:live], :to => :new
    end
    event :discard do
      transitions :from => [:new], :to => :quashed
      transitions :from => [:live], :to => :quashed
    end
    event :revive do
      transitions :from => [:quashed], :to => :new
    end
  end
  
  def join! user
    if self.users.empty?
      started = true
    end

    self.users << user
    self.save!

    if started
      self.change_status!
      Update.create!(:author => user,
                     :text => "started",
                     :project => self)
    else
      Update.create!(:author => user,
                     :text => "joined",
                     :project => self)
    end
  end
  
  def leave! user
    self.users -= [ user ]
    self.save!
    
    # If the last user has left...
    if self.users.empty?
      self.abandon!
    end

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
  
  def add_keyword! name, user
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

    Update.create!(:author => user,
                   :text => "added keyword \"#{name}\" to",
                   :project => self)
  end

  def remove_keyword! name, user
    keyword = Keyword.find_by_name name
    if self.keywords.include? keyword
      self.keywords.delete(keyword)
      save!
    end

    Update.create!(:author => user,
                   :text => "removed keyword #{name} from",
                   :project => self)
  end

    def create_initial_update
    Update.create!(:author => self.originator,
                   :text => "originated",
                   :project => self)
  end
end
