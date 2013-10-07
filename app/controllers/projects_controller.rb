class ProjectsController < ApplicationController

  load_and_authorize_resource
  skip_before_filter :authenticate_user!, :only => [ :index, :show, :archive, :newest, :popular, :biggest ]
  skip_before_filter :store_location, :only => [:join, :leave, :like, :dislike, :add_keyword, :delete_keyword ]
  skip_before_action :verify_authenticity_token, :only => [:add_keyword, :delete_keyword ]

  # GET /projects
  def index
    @projects = Project.where.not(aasm_state: "record").where.not(aasm_state: "invention")
  end

  # GET /projects/archived
  def archived
    @projects = Project.where(aasm_state: "record")
    render "index"
  end

  # GET /projects/finished
  def finished
    @projects = Project.where(aasm_state: "invention").order("updated_at DESC")
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

  # PUT /projects/1/advance
  def advance
    project = Project.find(params[:id])
    project.advance!

    respond_to do |format|
      format.html { redirect_to project }
      format.js { }
    end
  end

  # PUT /projects/1/recess
  def recess
    project = Project.find(params[:id])
    project.recess!

    respond_to do |format|
      format.html { redirect_to project }
      format.js { }
    end
  end

  # PUT /projects/1/join
  def join
    project = Project.find(params[:id])
    if project.aasm_state == "invention"
      redirect_to project, error: "You can't join this project as it's finished."
    end
    project.join! current_user

    respond_to do |format|
      format.html{ redirect_to project, notice: "Welcome to the project #{current_user.name}!" }
      format.js {}
    end
  end

  # PUT /projects/1/leave
  def leave
    project = Project.find(params[:id])
    if project.aasm_state == "invention"
      redirect_to project, error: "You can't leave this project as it's finished."
    end
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

  # GET projects/search
  def search
    search_result = Project.search { fulltext params[:search_string] }
    @projects = search_result.results
    render 'index'
  end

  def project_params
    params.require(:project).permit(:description, :title)
  end

  def keyword_params
    params.require(:keyword)
  end

end
