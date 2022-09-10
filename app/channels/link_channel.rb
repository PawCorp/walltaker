class LinkChannel < ApplicationCable::Channel
  def subscribed
    if params[:id].present?
      link = Link.find(params[:id])
      if link
        connection.watched_link = link
        link.live_client_started_at = Time.now
        link.save
        stream_from "Link::#{params[:id]}"
      end
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
