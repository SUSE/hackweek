class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers
  include Rakismet::Model
  include AkismetValidation

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :commenter, class_name: 'User'
  alias_attribute :originator, :commenter

  validates_presence_of :commenter_id, :text, :commentable_id
  validate :akismet_spam

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  def project
    return @project if defined?(@project)

    @project = commentable.is_a?(Project) ? commentable : commentable.project
  end

  def send_notification(sender, message)
    recipients = project.project_followers - [sender]

    recipients.each do |recipient|
      Notification.create(recipient: recipient, actor: sender, action: message, notifiable: project)
    end
  end

  ## used by rakismet
  # name submitted with the comment, used by rakismet
  def author
    commenter.try(:name)
  end

  # email submitted with the comment, used by rakismet
  def author_email
    commenter.try(:email)
  end

  # the content submitted, used by rakismet
  def content
    text
  end

  # the permanent URL for the entry the comment belongs to
  def permalink
    project_url(Episode.active, project, host: Rails.application.config.rakismet.url)
  end
end
