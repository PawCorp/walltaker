class ApiController < ApplicationController
  after_action :log_presence, only: %i[show_link show_link_widget]
  skip_before_action :verify_authenticity_token, only: :set_link_response

  # GET /api/links/:id.json
  def show_link
    @link = Link.find(params[:id])
    @set_by = User.find(@link.set_by_id) if @link.set_by_id
  rescue
    render json: { message: 'This link does not exist.' }, status: 404
  end

  def show_link_widget
    @link = Link.find(params[:id])
    @set_by = User.find(@link.set_by_id) if @link.set_by_id
  rescue
    render json: { message: 'This link does not exist.' }, status: 404
  end

  # POST /api/links/:id/response.json
  def set_link_response
    params.permit(:type, :text)
    @link = Link.find(params[:id])
    @set_by = User.find(@link.set_by_id) if @link.set_by_id
    valid = !@link.user.api_key.nil? && @link.user.api_key == params[:api_key]

    unless valid
      return render json: { message: 'Bad API key. Get an API key from your profile page on Walltaker.joi.how' }, status: 403
    end

    begin
      @link.response_type = params[:type].nil? ? "horny" : params[:type]
    rescue
      return render json: { message: 'type must be "horny", "disgust", or "came"' }, status: 400
    end

    @link.response_text = params[:text].nil? ? "" : params[:text]

    @link = on_link_react(@link)

    result = @link.save

    if result
      return render partial: 'link', locals: { link: @link, set_by: @set_by }
    else
      return render json: { message: 'Bad request body, something with the response you sent looks malicious.' }, status: 400
    end
  rescue => e
    track :error, :api_link_missing_while_setting_response, id: params[:id], message: e.message
    return render json: { message: 'This link does not exist.', e: e }, status: 404
  end

  # GET /api/users/:username.json
  def show_user
    if params['api_key'].present?
      current_user_or_api_user = User.find_by(api_key: params['api_key'])
    else
      current_user_or_api_user = current_user.present? ? current_user : nil
    end

    @user = User.find_by(username: params[:username])
    @has_friendship = Friendship.find_friendship(current_user_or_api_user, @user).exists? if current_user_or_api_user
    online_links = @user.link.where(friends_only: false).and(@user.link.where('expires > ?', Time.now).or(@user.link.where(never_expires: true))).and(@user.link.is_online) unless @has_friendship
    online_links = @user.link.where('expires > ?', Time.now).or(@user.link.where(never_expires: true)).and(@user.link.is_online) if @has_friendship

    @is_self = @user.id == current_user_or_api_user.id if current_user_or_api_user
    @is_self = false unless current_user_or_api_user
    @is_online = online_links.count > 0
    @is_authenticated = !!current_user_or_api_user
    @public_links = @user.link.where(friends_only: false).and(@user.link.where('expires > ?', Time.now).or(@user.link.where(never_expires: true)))
  rescue => e
    track :error, :api_user_missing, username: params[:username], message: e.message
    render json: { message: 'This user does not exist.' }, status: 404
  end

  private

  def log_presence
    log_link_presence(@link)
  rescue => e
    track :error, :api_link_missing, id: params[:id], message: e.message
  end
end
