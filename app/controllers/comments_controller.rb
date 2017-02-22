class CommentsController < ApplicationController

  before_filter :get_parent

  def new
    @comment = @parent.comments.build
  end

  def create
    @comment = @parent.comments.build(comment_params)
    @comment.commenter = current_user

    if @comment.save
      redirect_to project_path(@comment.project), :notice => 'Thank you for your comment!'
    else
      render :new
    end
  end

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :commenter_id, :text, :commenter)
  end

  protected

  def get_parent
    @parent = Project.find_by(url: params[:project_id]) if params[:project_id]
    @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]

    redirect_to root_path unless defined?(@parent)
  end
end
