class ApplicationController < ActionController::Base

  private

  # @param [Symbol<:regular, :nefarious, :visit>] level
  # @param [Symbol, String] id
  def track (level, id, **details)
    action = "#{controller_name}##{action_name}"

    event_name = "#{level}:#{id}"

    all_details = { _action: action }.merge details
    all_details = { _url: request.url } if level == :visit && request && request.url
    all_details = all_details.merge({ _link_id: @link.id, _link_owner_id: @link.user_id }) if @link
    all_details = all_details.merge({ _user_id: @user.id }) if @user
    all_details = all_details.merge({ _past_link_id: @past_link.id }) if @past_link

    ahoy.track event_name, all_details
  end

  def track_visit
    track :visit, request.path unless request.format == :json
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def notifications
    if current_user
      Notification.all.where(user: current_user).order(id: :desc).limit(5)
    else
      []
    end
  end

  helper_method :notifications

  def log_link_presence (link)
    if request.format == :json
      link.last_ping = Time.now.utc
      link.last_ping_user_agent = request.user_agent if request.user_agent
      link.last_ping_user_agent = @link.last_ping_user_agent + ' ' + request.headers['joihow'] if @link.last_ping_user_agent && request.headers['joihow']
      link.last_ping_user_agent = @link.last_ping_user_agent + ' ' + request.headers['User_Agent'] if @link.last_ping_user_agent && request.headers['User_Agent']
      link.last_ping_user_agent = @link.last_ping_user_agent + ' Wallpaper-Engine-Client/' + request.headers['Wallpaper-Engine-Client'] if @link.last_ping_user_agent && request.headers['Wallpaper-Engine-Client']
      link.save
    end
  end

  def on_link_react (link)
    # Make notification for setter
    notification_text = "#{link.user.username} loved your post!" if link.response_type == 'horny'
    notification_text = "#{link.user.username} did not like your post." if link.response_type == 'disgust'
    notification_text = "#{link.user.username} came to your post!" if link.response_type == 'came'
    notification_text = "#{notification_text} \"#{link.response_text}\"" unless link.response_type.nil?
    Notification.create user_id: link.set_by_id, notification_type: :post_response, text: notification_text, link: "/links/#{link.id}"

    # Log reaction in chat sidebar
    comment_text = "> loved it! #{ link.post_url }" if link.response_type == 'horny'
    comment_text = "> hated it. #{ link.post_url }" if link.response_type == 'disgust'
    comment_text = "> came to it! #{ link.post_url }" if link.response_type == 'came'
    Comment.create user_id: link.user.id, link_id: link.id, content: comment_text
    Comment.create user_id: link.user.id, link_id: link.id, content: link.response_text unless link.response_type.nil?

    # If a disgust reaction, revert to old wallpaper
    if link.response_type == 'disgust'
      past_links = PastLink.where(link_id: link.id, post_url: link.post_url)
      past_links.destroy_all unless past_links.empty?

      last_past_link = PastLink.where(link_id: link.id).where.not(post_url: link.post_url).order('created_at').last

      link.post_url = last_past_link ? last_past_link.post_url : nil
      link.post_thumbnail_url = last_past_link ? last_past_link.post_thumbnail_url : nil
    end

    link
  end

  helper_method :log_link_presence

  def authorize
    redirect_to new_session_url, alert: 'Not authorized' if session[:user_id].nil?
  end

  def authorize_with_admin
    redirect_to '/', alert: 'Not authorized' unless current_user && current_user.admin
  end
end
