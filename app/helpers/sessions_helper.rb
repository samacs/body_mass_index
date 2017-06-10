module SessionsHelper
  def login(user)
    reset_session

    session[:user_id] = user.id
  end

  def logout
    @current_user = nil
    reset_session
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if
      session.key?(:user_id)
  end

  def logged_in?
    current_user.present?
  end

  def require_user
    return if logged_in?
    flash[:notice] = 'You need to log in first'
    redirect_to login_path
  end

  def require_no_user
    redirect_to_previous if logged_in?
  end
end
