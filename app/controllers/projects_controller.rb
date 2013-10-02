class ProjectsController < ApplicationController

  load_and_authorize_resource
  skip_before_filter :authenticate_user!, :only => [ :index, :show, :archive, :newest, :popular, :biggest ]
  skip_before_filter :store_location, :only => [:join, :leave, :like, :dislike ]

  # GET /projects
  def index
    @projects = Project.where.not(aasm_state: "record")
  end

  # GET /projects/archive
  def archive
    @projects = Project.where(aasm_state: "record")
    render "index"
  end

  # GET /projects/newest
  def newest
    @projects = Project.where.not(aasm_state: "record").order("created_at DESC LIMIT 10")
    render "index"
  end

  # GET /projects/popular
  def popular
    @projects = Project.where("likes_count > 0").where.not(aasm_state: "record").order("likes_count DESC")
    render 'index'
  end

  # GET /projects/biggest
  def biggest
    @projects = Project.where("memberships_count > 0").where.not(aasm_state: "record").order("memberships_count DESC")
    render 'index'
  end

  # GET /projects/1
  def show
    @project = Project.find(params[:id])
    @new_comment = Comment.new
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.originator = current_user

    if @project.save
      redirect_to @project
    else
      render action: "new"
    end
  end

  # PUT /projects/1
  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(project_params)
      redirect_to @project
    else
      render action: "edit" 
    end
  end

  # DELETE /projects/1
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js { }
    end
  end

  # PUT /projects/1/discard
  def discard
    project = Project.find(params[:id])
    project.discard!

    respond_to do |format|
      format.html { redirect_to project, notice: "Project archived. Collecting dust now." }
      format.js { }
    end
  end

  # PUT /projects/1/revive
  def revive
    project = Project.find(params[:id])
    project.revive!
    if params.include? :join
      project.join! current_user
    end

    respond_to do |format|
      format.html { redirect_to project, notice: "Project revived. Back from the dead!" }
      format.js { }
    end
  end

  # PUT /projects/1/join
  def join
    project = Project.find(params[:id])
    project.join! current_user

    respond_to do |format|
      format.html{ redirect_to project, notice: "Welcome to the project #{current_user.name}!" }
      format.js {}
    end
  end

  # PUT /projects/1/leave
  def leave
    project = Project.find(params[:id])
    project.leave! current_user

    respond_to do |format|
      format.html{ redirect_to project, notice: "Goodbye #{current_user.name}..." }
      format.js {}
    end
  end

  # PUT /projects/1/like
  def like
    project = Project.find(params[:id])
    project.like! current_user

    respond_to do |format|
      format.html{ redirect_to project, notice: "Thank you for your love #{current_user.name}!" }
      format.js { render :partial => "like_toggle" }
    end
  end

  # PUT /projects/1/dislike
  def dislike
    project = Project.find(params[:id])
    project.dislike! current_user
    
    respond_to do |format|
      format.html{ redirect_to project, notice: "Aaww Snap! You don't love me anymore?" }
      format.js { render :partial => "like_toggle" }
    end
  end

  # PUT /projects/1/add_keyword
  def add_keyword
    project = Project.find(params[:id])
    keywords = keyword_params.split(',')
    keywords.each do |word|
      project.add_keyword! word, current_user
    end

    respond_to do |format|
      format.html{ redirect_to project }
      format.js {}
    end
  end

  # PUT /projects/1/delete_keyword
  def delete_keyword
    project = Project.find(params[:id])
    keywords = keyword_params.split(',')
    keywords.each do |word|
      project.remove_keyword! word, current_user
    end

    respond_to do |format|
      format.html{ redirect_to project }
      format.js {}
    end
  end

  def project_params
    params.require(:project).permit(:description, :title)
  end

  def keyword_params
    params.require(:keyword)
  end

end
