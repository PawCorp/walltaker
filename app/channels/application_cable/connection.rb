module ApplicationCable
  class Connection < ActionCable::Connection::Base
    attr_accessor :watched_links, :current_user

    def connect
      @watched_links = []
      @current_user = connection_current_user
    end

    def disconnect
      self.watched_links.for do |link| 
        link.live_client_started_at = nil
        link.save
      end
      
      self.watched_links = []
      self.current_user&.leave_link
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
