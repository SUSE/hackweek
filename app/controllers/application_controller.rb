class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :store_location
  before_filter :authenticate_user!
  before_filter :load_news
  before_filter :set_episode


  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from ActionController::ParameterMissing, with: :parameter_empty

  protected

  # store last visited url unless it's the login/sign up path,
  # doesn't start with our base url or is an ajax call.
  def store_location
    return unless request.get?
    if (request.path != new_user_ichain_session_path &&
        request.path != new_user_ichain_registration_path &&
        !request.path.starts_with?(Devise.ichain_base_url) &&
        !request.xhr?)
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
      if a && !a.users.include?(current_user)
        @news = a
      else
        @news = nil
      end
    end
  end

  def keyword_tokens
    required_parameters :q
    render json: Keyword.find_keyword(params[:q])
  end

  def parameter_empty
    redirect_to(:back)
    flash['warn'] = 'Parameter missing...'
  end

  def set_episode
    if params[:episode].blank?
      @episode = Episode.active
    else
      if params[:episode] == 'all'
        @episode = :all
      else
        @episode = Episode.find_by(id: params[:episode])
      end
    end
    logger.debug("\n\nEpisode: #{@episode}\n\n")
  end
end
