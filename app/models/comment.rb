class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  belongs_to :commenter, class_name: User

  validates_presence_of :commenter_id, :text, :commentable_id

  def project
    return @project if defined?(@project)
    @project = commentable.is_a?(Project) ? commentable : commentable.project
  end
end
