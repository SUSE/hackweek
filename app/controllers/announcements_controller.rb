class AnnouncementsController < ApplicationController
  load_and_authorize_resource params_method: :announcement_params
  skip_before_action :authenticate_user!, only: [ :index ]
  skip_before_action :store_location, only: [ :enroll ]

  # GET /announcements
  def index
    @announcements = Announcement.all.order('id DESC')
  end

  # GET /announcements/1
  def show
  end

  # GET /announcements/new
  def new
  end

  # GET /announcements/1/edit
  def edit
  end

  # POST /announcements
  def create
    @announcement.originator = current_user

    if @announcement.save
      redirect_to announcements_path, notice: 'Announcement was successfully created.'
    else
      render action: 'new'
    end
  end

  # PUT /announcements/1
  def update
    if @announcement.update_attributes(announcement_params)
      redirect_to announcements_path, notice: 'Announcement was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /announcements/1
  def destroy
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to announcements_path, notice: 'Announcement was successfully deleted.' }
      format.js { }
    end
  end

  # GET /annoucements/1/enroll
  def enroll
    announcement = Announcement.find(params[:id])
    announcement.enroll! current_user

    respond_to do |format|
      format.html{ redirect_to :back }
      format.js { render partial: 'announcement_toggle' }
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:title, :text)
  end
end
