class CommentsController < ApplicationController
  include MarkdownHelper

  before_action :get_parent, only: %i[create update]
  load_and_authorize_resource except: :index
  authorize_resource only: :index
  skip_before_action :verify_authenticity_token, only: [:reply_modal]

  def index
    @comments = Comment.accessible_by(current_ability).order(id: :desc).page(params[:page])
  end

  def create
    @comment = @parent.comments.build(comment_params)
    @comment.commenter = current_user

    if @comment.save
      @comment.send_notification(current_user,
                                 " commented on #{@comment.project.aasm_state}: #{@comment.project.title}")
      redirect_to project_path(@comment.project), notice: 'Thank you for your comment!'
    else
      logger.info "Blocked spam comment from #{current_user.name}" if @comment.errors.of_kind?(:base, 'is spam')
      redirect_to project_path(@comment.project), alert: "Could not comment: #{@comment.errors.full_messages.to_sentence}"
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to project_path(@comment.project), notice: 'Comment was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: 'Comment was successfully deleted.' }
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
