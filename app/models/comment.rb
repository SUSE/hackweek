class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :commenter, class_name: 'User'

  validates_presence_of :commenter_id, :text, :commentable_id
  after_save ThinkingSphinx::RealTime.callback_for(:project, [:project])

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
end
