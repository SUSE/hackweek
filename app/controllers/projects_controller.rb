class ProjectsController < ApplicationController

  load_and_authorize_resource
  skip_before_filter :authenticate_user!, :only => [ :index, :show, :archived, :finished, :newest, :popular, :biggest, :overview ]
  skip_before_filter :store_location, :only => [:join, :leave, :like, :dislike, :add_keyword, :delete_keyword ]
  skip_before_action :verify_authenticity_token, :only => [:add_keyword, :delete_keyword ]
  skip_load_and_authorize_resource :only => :old_archived
  before_action :set_episode_id, :only => [:add_episode, :delete_episode]

  # GET /projects
  def index
    @projects = Project.by_episode(@episode).active
  end

  # GET /projects/overview
  def overview
    @projects = Project.by_episode(Episode.active).active
    @popular = Project.by_episode(Episode.active).liked.order("likes_count DESC").first(5)
    @new = Project.by_episode(Episode.active).active.order("created_at ASC").last(5)
  end

  # GET /projects/popular
  def popular
    @projects = Project.by_episode(@episode).liked.order("likes_count DESC")
    render 'index'
  end

  # GET /projects/archived
  def archived
    @projects = Project.by_episode(@episode).archived
    render "index"
  end

  # GET /projects/biggest
  def biggest
    @projects = Project.by_episode(@episode).populated.order("memberships_count DESC")
    render 'index'
  end

  # GET /projects/finished
  def finished
    @projects = Project.by_episode(@episode).finished
    render "index"
  end

  # GET /projects/1
  def show
    @previous_project = @project.previous(@episode)
    @next_project = @project.next(@episode)
    @new_comment = Comment.new
  end

  # GET /archive/projects/:id
  def old_archived
    begin
      @project = Project.find_by!(title: params[:id])
      redirect_to @project
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Can't find project with title #{params[:id]}"
      redirect_to :action => :archived
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.originator = current_user

    if @project.save
      redirect_to project_path(@episode, @project), notice: "Project was successfully created."
    else
      render action: "new"
    end
  end

  # PUT /projects/1
  def update
    if @project.update_attributes(project_params)
      redirect_to project_path(@episode, @project)
    else
      render action: "edit" 
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_path(@episode)
  end

  # PUT /projects/1/advance
  def advance
    @project.advance!
    redirect_to project_path(@episode, @project)
  end

  # PUT /projects/1/recess
  def recess
    @project.recess!
    redirect_to project_path(@episode, @project)
  end

  # PUT /projects/1/join
  def join
    # FIXME: This is a validation
    if @project.aasm_state == "invention"
      redirect_to project, error: "You can't join this project as it's finished."
    end

    @project.join! current_user
    redirect_to project_path(@episode, @project), notice: "Welcome to the project #{current_user.name}!"
  end

  # PUT /projects/1/leave
  def leave
    # FIXME: This is a validation
    if @project.aasm_state == "invention"
      redirect_to @project, error: "You can't leave this project as it's finished."
    end

    @project.leave! current_user
    redirect_to project_path(@episode, @project), notice: "Goodbye #{current_user.name}..."
  end

  # PUT /projects/1/like
  def like
    @project.like! current_user

    respond_to do |format|
      format.html{ redirect_to project_path(@episode, @project), notice: "Thank you for your love #{current_user.name}!" }
      format.js { render :partial => "like_toggle" }
    end
  end

  # PUT /projects/1/dislike
  def dislike
    @project.dislike! current_user
    
    respond_to do |format|
      format.html{ redirect_to project_path(@episode, @project), notice: "Aaww Snap! You don't love me anymore?" }
      format.js { render :partial => "like_toggle" }
    end
  end

  # PUT /projects/1/add_keyword
  def add_keyword
    keywords = keyword_params.split(',')
    keywords.each do |word|
      @project.add_keyword! word, current_user
    end

    redirect_to project_path(@episode, @project), notice: "Added keywords #{keywords.join(', ')}"
  end

  # PUT /projects/1/delete_keyword
  def delete_keyword
    keywords = keyword_params.split(',')
    keywords.each do |word|
      @project.remove_keyword! word, current_user
    end

    redirect_to project_path(@episode, @project), notice: "Removed keywords #{keywords.join(', ')}"
  end

  # PUT /projects/1/add_hackweek/1
  def add_episode
    unless @project.episodes.include? @subject
      @project.episodes << @subject
    end

    redirect_to project_path(@episode, @project), notice: "Added hackweek #{@subject.name}"
  end

  # DELETE /projects/1/delete_hackweek/2
  def delete_episode
    @project.episodes.delete(@subject)
    redirect_to project_path(@episode, @project), notice: "Removed hackweek #{@subject.name}"
  end

  private

    def project_params
      params.require(:project).permit(:description, :title, :avatar)
    end
  
    def keyword_params
      params.require(:keyword)
    end
    
    def set_episode_id
      @subject = Episode.find(params[:episode_id])
    end
 
end
