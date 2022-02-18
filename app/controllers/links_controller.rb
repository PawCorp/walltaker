# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authorize, only: %i[index new edit create destroy]
  after_action :log_presence, only: %i[show]
  before_action :set_link, only: %i[show edit update destroy export]
  before_action :prevent_public_expired, only: %i[show update]
  before_action :protect_friends_only_links, only: %i[show update]

  # GET /links or /links.json (only your links)
  def index
    @links = User.find(current_user.id).link
  end

  # GET /browse (all online links)
  def browse
    @links = Link.all
                 .where(friends_only: false)
                 .where('expires > ?', Time.now)
                 .where('last_ping > ?', Time.now - 1.minute)
  end

  # GET /links/1 or /links/1.json
  def show
    @set_by = User.find(@link.set_by_id) if @link.set_by_id && request.format == :json
  end

  # GET /links/new
  def new
    @link = Link.new
    @link.expires = Time.now.utc + 1.days
  end

  # GET /links/1/edit
  def edit; end

  # POST /links or /links.json
  def create
    @link = Link.new(link_params)
    @link.user_id = current_user.id

    respond_to do |format|
      if @link.save
        format.html { redirect_to link_url(@link), notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  def update
    if update_request_unsafe?
      redirect_to link_url(@link), alert: 'Not authorized.'
      return
    end

    e621_post = request_post(params['link'][:post_id]) unless params['link'][:post_id].nil?
    blacklist = @link.blacklist.split(' ') unless @link.blacklist.nil?

    if e621_post.nil? && params['link'][:post_id]
      redirect_to link_url(@link), alert: 'Post could not be found.'
      return
    end

    if !e621_post.nil? && !(%w[png jpg bmp webp].include? e621_post['post']['file']['ext'])
      redirect_to link_url(@link), alert: 'Post is not a non-animated image.'
      return
    end

    if !blacklist.nil? && !e621_post.nil? && post_blacklisted?(blacklist, e621_post)
      redirect_to link_url(@link), alert: 'Post was blacklisted.'
      return
    end

    result = if e621_post.nil?
               @link.update(link_params)
             else
               @link.update(
                 HashWithIndifferentAccess.new(
                   {
                     post_url: e621_post['post']['file']['url'],
                     post_thumbnail_url: e621_post['post']['preview']['url'],
                     post_description: e621_post['post']['description'],
                     set_by_id: current_user.nil? ? nil : current_user.id
                   }
                 )
               )
             end

    respond_to do |format|
      if result
        format.html { redirect_to link_url(@link), notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1 or /links/1.json
  def destroy
    if current_user.id != @link.user.id
      redirect_to link_url(@link), alert: 'Not authorized.'
      return
    end
    @link.destroy

    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export
    render layout: nil, content_type: 'application/toml'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.find(params[:id])
  end

  def prevent_public_expired
    @is_expired = @link.expires <= Time.now.utc

    redirect_to root_url, alert: 'That link was expired!' if @is_expired && current_user.id != @link.user.id
  end

  # Only allow a list of trusted parameters through.
  def link_params
    params.require(:link).permit(:expires, :terms, :blacklist, :friends_only)
  end

  def post_blacklisted?(blacklist, e621_post)
    blacklisted_in_general_tags = (blacklist & e621_post['post']['tags']['general']).any?
    blacklisted_in_species_tags = (blacklist & e621_post['post']['tags']['species']).any?
    blacklisted_in_artist_tags = (blacklist & e621_post['post']['tags']['artist']).any?
    blacklisted_in_character_tags = (blacklist & e621_post['post']['tags']['character']).any?
    blacklisted_in_general_tags || blacklisted_in_species_tags || blacklisted_in_artist_tags || blacklisted_in_character_tags
  end

  def update_request_unsafe?
    user_trying_to_update_others_link_restricted_values = (current_user && ((current_user.id != @link.user.id) && !link_params.empty?))
    unauthed_user_trying_to_update_others_link_restricted_values = (current_user.nil? && !link_params.empty?)
    user_trying_to_update_others_link_restricted_values || unauthed_user_trying_to_update_others_link_restricted_values
  end

  def request_post(post_id)
    response = Excon.get(
      "https://e621.net/posts/#{post_id.to_i}.json"
    )
    return nil if response.status != 200

    JSON.parse(response.body)
  end

  def protect_friends_only_links
    unless request.format == :json
      authorize if @link.friends_only

      unless current_user.nil?
        friendship_exists = Friendship.find_friendship(@link.user, current_user).exists?
        if @link.friends_only && !friendship_exists && (current_user.id != @link.user.id)
          return redirect_to root_url, alert: 'Not Authorized'
        end
      end
    end
  end

  def log_presence
    if request.format == :json
      @link.last_ping = Time.now.utc
      @link.save
    end
  end
end
