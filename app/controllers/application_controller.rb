class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :store_location
  before_action :authenticate_user!
  before_action :load_news
  before_action :set_episode
  before_action :load_notifications

  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from ActionController::ParameterMissing, with: :parameter_empty
  rescue_from ActiveRecord::RecordNotFound do
    render file: Rails.root.join('public/404'), status: 404, layout: false
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_url, alert: exception.message }
    end
  end

  protected

  # store last visited url unless it's the login/sign up path,
  # doesn't start with our base url or is an ajax call.
  def store_location
    return unless request.get?

    if request.path != new_user_ichain_session_path &&
       request.path != new_user_ichain_registration_path &&
       !request.path.starts_with?(Devise.ichain_base_url) &&
       !request.xhr?
      session[:return_to] = request.fullpath
    end
  end

  # after sign in redirect to the stored location
  def after_sign_in_path_for(_resource)
    session[:return_to] || root_path
  end

  # after sign out redirect to projects
  def after_sign_out_path_for(_resource)
    projects_path
  end

  def load_news
    if user_signed_in?
      a = Announcement.last
      @news = (a if a && !a.users.include?(current_user))
    end
  end

  def parameter_empty
    redirect_to(:back)
    flash['warn'] = 'Parameter missing...'
  end

  def set_episode
    @episode = if params[:episode].blank?
                 Episode.active
               elsif params[:episode] == 'all'
                 :all
               else
                 Episode.find(params[:episode])
               end
    logger.debug("\n\nEpisode: #{@episode.to_param}\n\n")
  end

  def load_notifications
    @notifications = Notification.where(recipient: current_user).unread if user_signed_in?
  end
end
