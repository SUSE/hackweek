class EpisodesController < ApplicationController
  load_and_authorize_resource
  before_action :set_episode, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, :only => [ :index, :show]

  # GET /episodes
  def index
    @episodes = Episode.all.order("start_date DESC")
  end

  # GET /episodes/1
  def show
  end

  # GET /episodes/new
  def new
    @episode = Episode.new
  end

  # GET /episodes/1/edit
  def edit
  end

  # POST /episodes
  def create
    @episode = Episode.new(episode_params)

    if @episode.save
      redirect_to episodes_path, notice: 'Episode was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /episodes/1
  def update
    if @episode.update(episode_params)
      redirect_to episodes_path, notice: 'Episode was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /episodes/1
  def destroy
    @episode.destroy
    redirect_to episodes_path, notice: 'Episode was successfully destroyed.'
  end

  # PUT /episodes/1/activate
  def activate
    @episode.active=true
    redirect_to episodes_path, notice: "#{@episode.name} is now active."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def episode_params
      params.require(:episode).permit(:name, :start_date, :end_date, :description)
    end
end
