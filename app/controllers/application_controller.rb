class ApplicationController < ActionController::Base

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def authorize
    redirect_to new_session_url, alert: 'Not authorized' if session[:user_id].nil?
  end
end
