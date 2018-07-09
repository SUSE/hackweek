class ProjectsController < ApplicationController

  before_filter :find_project_by_id
  before_filter :redirect_to_slug, only: [:show]
  load_and_authorize_resource find_by: :url
  skip_before_filter :authenticate_user!, only: [ :index, :show, :archived, :finished, :newest, :popular, :biggest, :random ]
  skip_before_filter :store_location, only: [:join, :leave, :like, :dislike, :add_keyword, :delete_keyword ]
  skip_before_action :verify_authenticity_token, only: [:add_keyword, :delete_keyword ]
  before_action :load_episode
  before_action :username_array, only: [:new, :edit, :show]
  autocomplete :project, :title

  # GET /projects
  # GET /projects.rss
  def index
    @projects = Project.current(@episode).active.includes(:episode_project_associations, :originator, :users).
        order('episodes_projects.created_at DESC').references(:episodes_projects).page(params[:page]).per(params[:page_size])
    @newest = @projects.first(10)
    respond_to do |format|
      format.html { render }
      format.rss { render :layout => false }
      format.js
    end
  end

  # GET /projects/popular
  def popular
    @projects = Project.current(@episode).liked.includes(:originator, :users, :kudos).order('likes_count DESC').page(params[:page]).per(params[:page_size])
    render 'index'
  end

  # GET /projects/archived
  def archived
    @projects = Project.current(@episode).archived.includes(:originator, :users, :kudos).page(params[:page]).per(params[:page_size])
    render 'index'
  end

  # GET /projects/biggest
  def biggest
    @projects = Project.current(@episode).populated.includes(:originator, :users, :kudos).order('memberships_count DESC').page(params[:page]).per(params[:page_size])
    render 'index'
  end

  # GET /projects/finished
  def finished
    @projects = Project.current(@episode).finished.includes(:originator, :users, :kudos).page(params[:page]).per(params[:page_size])
    render 'index'
  end

  # GET /projects/1
  def show
    @similar_projects = (@project.similar_projects - [@project]).sample(5)
    @previous_project = @project.previous(@episode)
    @next_project = @project.next(@episode)
    @new_comment = Comment.new
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
      redirect_to project_path(@episode, @project), notice: 'Project was successfully created.'
    else
      render action: 'new'
    end
  end

  # PUT /projects/1
  def update
    if @project.update_attributes(project_params)
      redirect_to project_path(@episode, @project)
    else
      render action: 'edit'
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
    respond_to do |format|
      if @project.join!(current_user)
        format.js { flash['success'] = "Welcome to the project #{current_user.name}." }
      else
        format.js { flash['error'] = "#{@project.errors.full_messages.to_sentence}" }
      end
    end
    flash.discard
  end

  # PUT /projects/1/leave
  def leave
    respond_to do |format|
      if @project.leave!(current_user)
        format.js { flash['success'] = "Sorry to see you go #{current_user.name}." }
      else
        format.js { flash['error'] = "#{@project.errors.full_messages.to_sentence}" }
      end
    end
    flash.discard
  end

  # PUT /projects/1/like
  def like
    @project.like! current_user

    respond_to do |format|
      format.html{ redirect_to project_path(@episode, @project), notice: "Thank you for your love #{current_user.name}!" }
      format.js { render partial: 'like_toggle' }
    end
  end

  # PUT /projects/1/dislike
  def dislike
    @project.dislike! current_user

    respond_to do |format|
      format.html{ redirect_to project_path(@episode, @project), notice: "Aaww Snap! You don't love me anymore?" }
      format.js { render partial: 'like_toggle' }
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
    unless @project.episodes.include? @episode
      @project.episodes << @episode
    end

    redirect_to project_path(@episode, @project), notice: "Added hackweek #{@episode.name}"
  end

  # DELETE /projects/1/delete_hackweek/2
  def delete_episode
    @project.episodes.delete(@episode)
    redirect_to project_path(nil, @project), notice: "Removed hackweek #{@episode.name}"
  end

  # GET /projects/random
  def random
    projects = Project.current(@episode).active
    # I can do this with a single query, but that won't be testable or database-agnostic
    @project = projects.offset(Kernel.rand(projects.size)).first
    render layout: 'zoomed'
  end

  private

    def project_params
      params.require(:project).permit(:description, :title, :avatar)
    end

    def keyword_params
      params.require(:keyword)
    end

    def load_episode
      @episode = Episode.find(params[:episode_id]) if params[:episode_id]
    end

    def find_project_by_id
      @project = Project.find_by(id: params[:id]) if Project.numeric?(params[:id])
    end

    def redirect_to_slug
      redirect_to @project if @project
    end

    def username_array
      @username_array = User.pluck(:name).compact.to_json
    end
end
