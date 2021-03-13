class Project < ApplicationRecord
  include AASM
  is_impressionable

  validates :title, :description, :originator, presence: true
  validate  :title_contains_letters?
  validates :url, uniqueness: true

  belongs_to :originator, class_name: 'User'

  has_many :likes
  has_many :kudos, through: :likes, source: :user

  has_many :updates, -> { order 'created_at DESC' }, dependent: :destroy

  has_many :comments, as: :commentable, dependent: :destroy

  has_and_belongs_to_many :keywords
  has_and_belongs_to_many :episodes
  has_and_belongs_to_many :users

  has_many :project_follows
  has_many :project_followers, through: :project_follows, source: :user

  has_attached_file :avatar, styles: { thumb: '64x64>' }, default_url: :random_avatar
  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\Z}

  after_create :create_initial_update
  after_create :assign_episode

  after_save ThinkingSphinx::RealTime.callback_for(:project)
  acts_as_url :title, blacklist: %w[new archived finished newest popular biggest random]

  aasm do
    state :idea, initial: true
    state :project
    state :invention
    state :record

    event :advance do
      transitions from: [:idea], to: :project
      transitions from: [:project], to: :invention
      transitions from: [:record], to: :idea
    end
    event :recess do
      transitions from: [:project], to: :idea
      transitions from: [:idea], to: :record
      transitions from: [:invention], to: :project
    end
    event :abandon do
      transitions from: [:project], to: :idea
      transitions from: [:invention], to: :invention
    end
  end

  scope :ideas, -> { where(aasm_state: 'idea') }
  scope :finished, -> { where(aasm_state: 'invention') }
  scope :archived, -> { where(aasm_state: 'record') }
  scope :liked, -> { where('likes_count > 0') }
  scope :populated, -> { where('memberships_count > 0') }
  scope :by_episode, lambda { |episode|
    joins(:episodes).where(episodes: { id: episode.id }) if episode && episode.is_a?(Episode)
  }

  def self.current(episode = nil)
    if !episode.nil? && episode.is_a?(Episode)
      joins(:episodes).where(episodes: { id: episode.id })
    else
      all
    end
  end

  def self.active
    where.not(aasm_state: 'record').where.not(aasm_state: 'invention')
  end

  def active?
    idea? || project?
  end

  def joined(user)
    return false if users.empty?
    return false unless users.include? user
    return true if users.include? user
  end

  def join!(user)
    if users.include?(user)
      errors.add(:base, 'You already joined this project.')
      return false
    end

    if aasm_state == 'invention'
      errors.add(:base, "You can't join this project as it's finished.")
      return false
    end

    if users.empty?
      advance!
      type = 'started'
    else
      type = 'joined'
    end

    users << user
    save!

    Update.create!(author: user,
                   text: type,
                   project: self)
  end

  def leave!(user)
    unless users.include?(user)
      errors.add(:base, 'You are not member of this project.')
      return false
    end

    if aasm_state == 'invention'
      errors.add(:base, "You can't leave this project as it's finished.")
      return false
    end
    users.delete(user)

    # If the last user has left...
    abandon! if users.empty?

    Update.create!(author: user,
                   text: 'left',
                   project: self)
  end

  def like!(user)
    return if kudos.include? user

    kudos << user
    save!

    Update.create!(author: user,
                   text: 'liked',
                   project: self)
  end

  def dislike!(user)
    self.kudos -= [user]
    save!

    Update.create!(author: user, project: self, text: 'disliked')
  end

  def add_keyword!(name, user)
    name.downcase!
    name.gsub!(/\s/, '')
    keyword = Keyword.find_by_name name
    keyword ||= Keyword.create! name: name
    unless keywords.include? keyword
      keywords << keyword
      save!
    end

    Update.create!(author: user, project: self,
                   text: "added keyword \"#{name}\" to")
  end

  def remove_keyword!(name, user)
    keyword = Keyword.find_by_name name
    if keywords.include? keyword
      keywords.delete(keyword)
      save!
    end

    Update.create!(author: user,
                   text: "removed keyword #{name} from",
                   project: self)
  end

  def similar_projects_keywords
    return [] if keywords.empty?

    similar_keys = keywords.select { |word| (word.projects.current(Episode.active) - [self]).any? }
  end

  def send_notification(sender, message)
    recipients = project_followers - [sender]
    recipients.each do |recipient|
      Notification.create(recipient: recipient, actor: sender, action: message, notifiable: self)
    end
  end

  def previous(episode = nil)
    Project.by_episode(episode).where('projects.id < ?', id).last
  end

  def next(episode = nil)
    Project.by_episode(episode).where('projects.id > ?', id).first
  end

  def comment_texts
    comments.collect(&:text).join(' ')
  end

  def to_param
    url
  end

  def self.numeric?(whatever)
    !Float(whatever).nil?
  rescue StandardError
    false
  end

  def self.description_template
    File.open(Rails.root.join('config', 'new_project_template.md')).read
  end

  private

  def title_contains_letters?
    errors.add(:title, 'must contain letters') if Project.numeric?(title)
  end

  def create_initial_update
    Update.create!(author: originator,
                   text: 'originated',
                   project: self)
  end

  def assign_episode
    episodes << Episode.active if Episode.active
  end

  def random_avatar
    avatars = %w[chisel drill hammer hand-file hand-plane pliers ruler saw screwdriver wrench]
    "avatars/#{avatars.sample}_:style.png"
  end
end
