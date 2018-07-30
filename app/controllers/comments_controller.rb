class CommentsController < ApplicationController
  include MarkdownHelper
  before_action :get_parent, except: :reply_modal
  skip_before_action :verify_authenticity_token, only: [:reply_modal]

  def new
    @comment = @parent.comments.build
  end

  def create
    @comment = @parent.comments.build(comment_params)
    @comment.commenter = current_user

    if @comment.save
      @comment.send_notification(current_user, " commented on #{@comment.project.aasm_state}: #{@comment.project.title}")
      redirect_to project_path(@comment.project), :notice => 'Thank you for your comment!'
    else
      render :new
    end
  end

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :commenter_id, :text, :commenter)
  end

  def reply_modal
    @comment = Comment.find(params[:id])
    @content = @comment.text.to_str.gsub(/:([\w+-]+):/) do |match|
                 %(![add-emoji](https://assets-cdn.github.com/images/icons/emoji/#{match.to_str.tr(':','')}.png))
               end if @comment.text
    @rendered = MarkdownHelper.render @content
    respond_to do |format|
      format.html
      format.js
    end
  end

  protected

  def get_parent
    @parent = Project.find_by(url: params[:project_id]) if params[:project_id]
    @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]

    redirect_to root_path unless defined?(@parent)
  end
end
