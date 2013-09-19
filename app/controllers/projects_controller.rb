class ProjectsController < ApplicationController

  load_and_authorize_resource
  skip_before_filter :authenticate_user!, :only => [ :index, :show ]
  skip_before_filter :store_location, :only => [:join, :leave, :like, :dislike ]

  # GET /projects
  # GET /projects.json
  def index
    if params.include? "by_kudos"
      @projects = Project.order("likes_count DESC")
    elsif params.include? "by_devs"
      @projects = Project.order("memberships_count DESC")
    else
      @projects = Project.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @new_comment = Comment.new
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.originator = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to @project }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def discard
    project = Project.find(params[:id])
    project.discard!

    redirect_back_or_default project
    flash[:notice] = "Discarded project. Wasn't good enough huh?"
  end

  def revive
    project = Project.find(params[:id])
    project.revive!
    if params.include? :join
      project.join! current_user
    end

    redirect_back_or_default project
    flash[:notice] = "Revived project. Back from the dead!"
  end


  def join
    project = Project.find(params[:id])
    project.join! current_user
    
    redirect_back_or_default project
    flash[:notice] = "Welcome to the project #{current_user.name}!"
  end

  def leave
    project = Project.find(params[:id])
    project.leave! current_user
    
    redirect_back_or_default project
    flash[:notice] = "Goodbye #{current_user.name}!"
  end
  
  def like
    project = Project.find(params[:id])
    project.like! current_user
    
    redirect_back_or_default project
    flash[:notice] = "Thank you for your love #{current_user.name}!"
  end

  def dislike
    project = Project.find(params[:id])
    project.dislike! current_user
    
    redirect_back_or_default project
    flash[:notice] = "Aaww Snap!"
  end
  
  def add_keyword
    project = Project.find(params[:id])
    keywords = keyword_params.split(',')
    keywords.each do |word|
      project.add_keyword! word, current_user
    end
    redirect_to project
  end

  def delete_keyword
    project = Project.find(params[:id])
    keywords = keyword_params.split(',')
    keywords.each do |word|
      project.remove_keyword! word, current_user
    end
    redirect_to project
  end

  def project_params
    params.require(:project).permit(:description, :title)
  end

  def keyword_params
    params.require(:keyword)
  end

end
