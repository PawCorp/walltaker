module Nuttracker
  class ApplicationController < ActionController::Base
    def current_user
      @current_user ||= User.find(cookies.signed[:permanent_session_id]) if cookies.signed[:permanent_session_id]
      @current_user ||= User.find(session[:user_id]) if session[:user_id]

      @current_user
    end

    helper_method :current_user

    def authorize
      redirect_to '/', alert: 'Not authorized' if current_user.nil?
    end
  end
end
