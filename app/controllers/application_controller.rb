class ApplicationController < ActionController::Base

  private

  def get_tag_results(tag_string, after, before, link, limit = 15)
    if link.nil?
      append_to_tags = ''
      padded_tag_string = ''
      link_can_show_videos = true
    else
      link_can_show_videos = link.check_ability 'can_show_videos'

      sanitized_blacklist = make_blacklist(link)
      append_to_tags = make_tag_suffix(link, sanitized_blacklist)

      padded_tag_string = tag_string
    end

    unless append_to_tags.nil? || append_to_tags.empty?
      padded_tag_string += " #{append_to_tags.to_s}"
    end
    tags = CGI.escape padded_tag_string
    url = "https://e621.net/posts.json?tags=#{tags}&limit=15"
    after_id = after.gsub(/\D/, '') if after
    url = "#{url}&page=b#{after_id}" if after_id
    before_id = before.gsub(/\D/, '') if before
    url = "#{url}&page=a#{before_id}" if before_id
    url = "#{url}&limit=#{limit}" if limit
    response = Excon.get(url, headers: { 'User-Agent': 'walltaker.joi.how (by ailurus on e621)' })
    if response.status != 200
      track :error, :e621_posts_api_fail, response: response
      return nil
    end

    results = JSON.parse(response.body)['posts']

    if results.present? && results.class == Array
      unless link_can_show_videos
        results.filter do |post|
          %w[png jpg bmp webp].include? post['file']['ext']
        end
      else
        results
      end
    else
      []
    end
  end

  helper_method :get_tag_results

  def get_possible_post_count(link)
    (get_tag_results '', nil, nil, link, 150)&.count
  end

  helper_method :get_possible_post_count

  def make_tag_suffix(link, sanitized_blacklist)
    append_to_tags = ''
    append_to_tags += link.theme if (link.theme)
    append_to_tags += ' ' + ((sanitized_blacklist.split.map { |tag| "-#{tag}" }).join ' ') unless (sanitized_blacklist.empty?)
    append_to_tags += ' score:>' + link.min_score.to_s if link.min_score.present? && link.min_score != 0
    append_to_tags += ' -animated' unless link.check_ability 'can_show_videos'
    append_to_tags
  end

  def make_blacklist(link)
    link.blacklist.downcase.gsub(/[^a-z_\(\)\d\: ]/, '')
  end

  def get_search_base(link)
    sanitized_blacklist = make_blacklist(link)
    make_tag_suffix(link, sanitized_blacklist)
  end

  helper_method :get_search_base

  def get_post(id, link)
    result = get_tag_results "id:#{id}", nil, nil, link, 1
    result&.count&.positive? ? result[0] : nil
  end

  helper_method :get_post

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
    @current_user ||= User.find(cookies.signed[:permanent_session_id]) if cookies.signed[:permanent_session_id]
    @current_user ||= User.find(session[:user_id]) if session[:user_id]

    @current_user
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

  helper_method :log_link_presence

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

    # If a came reaction, log an orgasm
    Nuttracker::Orgasm.create rating: 3, is_ruined: false, user_id: link.user.id if link.response_type == 'came'

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

  def authorize
    redirect_to new_session_url, alert: 'Not authorized' if current_user.nil?
  end

  def authorize_with_admin
    redirect_to '/', alert: 'Not authorized' unless current_user && current_user.admin
  end
end
