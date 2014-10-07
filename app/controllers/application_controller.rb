class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :store_location
  before_filter :authenticate_user!
  before_filter :load_news
  before_filter :set_current_episode


  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from ActionController::ParameterMissing , with: :parameter_empty

  protected

  def howto
    render :layout => 'application'
  end

  def awards
    render :layout => 'application'
  end

  def after_sign_out_path_for(resource_or_scope)
    projects_path
  end

  def store_location
    if user_signed_in?
      if not request.fullpath === new_user_ichain_session_path and request.get?
        session['user_return_to'] = request.fullpath
      end
    end
  end

  def load_news
    if user_signed_in?
      a = Announcement.last
      if a and not a.users.include? current_user
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
    flash["alert-warning"] = 'Parameter missing...'
  end

  def set_current_episode
    if params[:episode].kind_of? String
      @episode = Episode.find_by(:id => params[:episode])
    elsif session[:episode]
      @episode = Episode.find_by(:id => session[:episode])
    end
    @episode = Episode.active unless @episode
    # and then we save the ID to the session
    session[:episode] = @episode
  end
end
