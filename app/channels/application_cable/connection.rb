module ApplicationCable
  class Connection < ActionCable::Connection::Base
    attr_accessor :watched_link

    def connect
      @watched_link = nil
    end
    def disconnect
      if self.watched_link
        self.watched_link.live_client_started_at = nil
        self.watched_link.save
      end
    end
  end
end
