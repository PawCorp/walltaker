class LinkChannel < ApplicationCable::Channel
  def subscribed
    if params[:id].present?
      link = Link.find(params[:id])
      if link
        link.live_client_started_at = Time.now
        link.save

        connection&.watched_links.push(link)
        stream_from "Link::#{params[:id]}"
      end
    end
  end

  def unsubscribed
    if params[:id].present?
      link = Link.find(params[:id])
      if link
        stop_stream_from "Link::#{params[:id]}"
        link.live_client_started_at = nil
        link.save

        connection&.watched_links.delete(link)
      end
    end
  end

  def check
    if params[:id].present?
      link = Link.find(params[:id])
      if link
        connection.watched_links.push(link)
        link.live_client_started_at = Time.now
        link.save
      end
    end
  end

  def announce_client(data)
    if params[:id].present? && data['client']
      link = Link.find(params[:id])
      if link
        begin
        link.last_ping_user_agent = data['client']
        link.save
        rescue
          {success: false, why: 'bad client name'}
        end
      end
    end
  end
end
