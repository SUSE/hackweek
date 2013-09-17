class CustomFailure < Devise::FailureApp
  def redirect_url
    new_user_ichain_session_path
  end
  def respond
    redirect
  end
end

