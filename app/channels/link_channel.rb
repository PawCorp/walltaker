class LinkChannel < ApplicationCable::Channel
  def subscribed
    stream_from "Link::#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
