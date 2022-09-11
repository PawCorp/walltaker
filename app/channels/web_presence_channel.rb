class WebPresenceChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    leave_link
  end

  def view_link(data)
    if data['link_id']
      link = Link.find(data['link_id'])
      if link && connection.current_user
        connection.current_user.view_link(link)
      end
    end
  end

  def leave_link
    if connection.current_user
      connection.current_user.leave_link
    end
  end
end
