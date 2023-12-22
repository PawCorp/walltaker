class LinkChannel < ApplicationCable::Channel
  def subscribed
    if params[:id].present?
      link = Link.find(params[:id])
      if link
        if connection&.watched_link
          connection.watched_link.live_client_started_at = nil
          connection.watched_link.save
        end
        connection.watched_link = link
        link.live_client_started_at = Time.now
        link.save
        stream_from "Link::#{params[:id]}"
      end
    end
  end

  def unsubscribed
    if connection&.watched_link
      connection.watched_link.live_client_started_at = nil
      connection.watched_link.save
    end
  end

  def check
    if params[:id].present?
      link = Link.find(params[:id])
      if link
        if connection&.watched_link
          connection.watched_link.live_client_started_at = nil
          connection.watched_link.save
        end
        connection.watched_link = link
        link.live_client_started_at = Time.now
        link.save

        link
      end
    end
  end
end
