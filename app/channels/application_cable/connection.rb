module ApplicationCable
  class Connection < ActionCable::Connection::Base
    attr_accessor :watched_link, :current_user

    def connect
      @watched_link = nil
      @current_user = connection_current_user
    end
    def disconnect
      if self.watched_link
        self.watched_link.live_client_started_at = nil
        self.watched_link.save
      end

      if self.current_user
        self.current_user.leave_link
      end
    end

    private

    def connection_current_user
      current_user = User.find(cookies.signed[:permanent_session_id]) if cookies.signed[:permanent_session_id]
      current_user = User.find(@request.session[:user_id]) if @request.session[:user_id]
      if current_user
        current_user
      else
        nil
      end
    end
  end
end
