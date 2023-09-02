# frozen_string_literal: true

class LinksController < ApplicationController
  ######
  # WELCOME TO HELL
  ######

  # 1. force auth for protected routes
  before_action :authorize, only: %i[index new edit create destroy]

  # 2. set @link instance var, since a lot of action filters use it
  before_action :set_link, only: %i[show edit update destroy export toggle_ability]

  # 3. protect link-specific buisness rules
  before_action :prevent_public_expired, only: %i[show update]
  before_action :protect_friends_only_links, only: %i[show update]
  before_action :skip_unauthorized_requests, only: %i[update toggle_ability], if: -> { update_request_unsafe? }

  # 4. save presence + analytics
  after_action :log_presence, only: %i[show]
  after_action :track_visit, only: %i[index browse new show edit]

  # GET /links or /links.json (only your links)
  def index
    @links = User.find(current_user.id).link
  end

  # GET /browse (all online links)
  def browse
    # FUCK YOU, I join what I want, get ready for the query from hell
    @links = Link.all
                 .where(friends_only: false)
                 .is_online
                 .and(
                   Link.all.where('expires > ?', Time.now).or(Link.all.where(never_expires: true))
                 )
                 .joins(:user)
                 .joins(:past_links)
                 .where('past_links.created_at = (SELECT MAX(created_at) FROM past_links WHERE past_links.link_id = links.id)')
                 .order(Arel.sql(%q{
                    CASE WHEN users.created_at > now() - interval '8 hours' THEN 1 ELSE 0 END DESC,
                    past_links.created_at - make_interval(secs := users.set_count * 6) ASC
                 }))
                 .limit(50)

  end

  # GET /links/1 or /links/1.json
  def show
    @has_friendship = Friendship.find_friendship(current_user, @link.user).exists? if current_user
    @set_by = User.find(@link.set_by_id) if @link.set_by_id && request.format == :json
    @is_current_user = (current_user && (current_user.id == @link.user.id))
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
    @link.custom_url = nil if @link.user.set_count < 300
    result = @link.save

    if params[:commit] == 'Update and Test'
      do_link_request_test
      return
    end

    respond_to do |format|
      if result
        track :regular, :new_link
        format.html { redirect_to link_url(@link), notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        track :error, :failed_to_create_new_link, errors: @link.errors
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  def update
    e621_post = get_post(params['link'][:post_id], @link) unless params['link'][:post_id].nil?

    if e621_post.nil? && params['link'][:post_id]
      redirect_to link_url(@link), alert: 'Post could not be found or was blacklisted.'
      track :nefarious, :user_blacklisted, attempted_post_id: params['link'][:post_id]
      return
    end

    if !e621_post.nil? && e621_post['file']['url'].nil?
      redirect_to link_url(@link), alert: 'Post was blacklisted by E621.'
      track :nefarious, :e621_blacklisted, attempted_post_id: params['link'][:post_id]
      return
    end

    result_of_link_model_save = if e621_post.nil?
                                  @link.assign_attributes(link_params)

                                  @link.custom_url = nil if @link.custom_url == ''
                                  @link.custom_url = nil if @link.user.set_count < 300

                                  unless link_params['response_type'].nil?
                                    @link = on_link_react(@link)
                                  end

                                  did_save_successfully = @link.save

                                  track :regular, :update_link_details
                                  did_save_successfully
                                else
                                  assign_e621_post_to_self e621_post, @link
                                end

    if params[:commit] == 'Update and Test'
      do_link_request_test
      return
    end

    respond_to do |format|
      if result_of_link_model_save
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
      track :nefarious, :delete_others_link
      return
    end
    @link.destroy
    track :regular, :delete_link

    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  def export
    track :regular, :export_link
    render layout: nil, content_type: 'application/toml'
  end

  def toggle_ability
    able_to = @link.check_ability params['ability']
    if able_to
      track :regular, :disabled_ability, ability_name: params['ability']
      @link.abilities.delete_by ability: params['ability']
    else
      track :regular, :enabled_ability, ability_name: params['ability']
      @link.abilities.create ability: params['ability']
    end
    redirect_to edit_link_path @link
  end

  def fork
    source_link = Link.find(params['id'])

    if source_link.friends_only
      friendship = Friendship.find_friendship(current_user, source_link.user)
      unless friendship.present?
        track :error, :failed_to_create_new_link_fork, source: params['id']
        render :new, status: :unprocessable_entity
        return
      end
    end

    if source_link
      @link = source_link.dup
      @link.user_id = current_user.id
      @link.custom_url = nil
      @link.created_at = Time.now
      @link.updated_at = Time.now
      @link.last_ping = nil
      @link.last_ping_user_agent = nil
      @link.response_type = nil
      @link.response_text = nil
      @link.live_client_started_at = nil
      @link.forked_from = source_link
      result = @link.save
    end

    if result
      track :regular, :link_fork, source: params['id'], clone: @link.id
      redirect_to link_url(@link), notice: 'Link was successfully forked.'
    else
      track :error, :failed_to_create_new_link_fork, errors: @link.errors, source: params['id']
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Guards

  def update_request_unsafe?
    user_trying_to_update_others_link_restricted_values = (current_user && ((current_user.id != @link.user.id) && !link_params.empty?))
    unauthed_user_trying_to_update_others_link_restricted_values = (current_user.nil? && !link_params.empty?)
    user_trying_to_update_others_link_restricted_values || unauthed_user_trying_to_update_others_link_restricted_values
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
    log_link_presence(@link)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    if params[:id].match? /\D+/
      @link = Link.find_by(custom_url: params[:id])
    else
      @link = Link.find(params[:id])
    end
  end

  def skip_unauthorized_requests
    track :nefarious, :edit_others_link
    redirect_to link_url(@link), alert: 'Not authorized.'
  end

  # Helpers

  def link_params
    params.require(:link).permit(:expires, :terms, :blacklist, :friends_only, :never_expires, :theme, :min_score, :response_text, :response_type, :custom_url)
  end

  def prevent_public_expired
    @is_expired = @link.never_expires ? false : @link.expires <= Time.now.utc
    current_user_is_not_owner = current_user && current_user.id != @link.user.id
    not_logged_in = current_user.nil?
    redirect_to root_url, alert: 'That link was expired!' if @is_expired && (current_user_is_not_owner || not_logged_in)
  end

  def do_link_request_test
    post_count = get_possible_post_count @link
    if post_count.nil?
      redirect_to edit_link_path(@link), alert: "E621 may be down. You can save your link for now, though we can't verify that posts match your filter criteria at the moment."
    end
    if post_count > 99
      redirect_to edit_link_path(@link), notice: "Many posts are selectable with these settings."
    elsif post_count > 30
      redirect_to edit_link_path(@link), notice: "Only #{post_count} #{'post'.pluralize post_count} can be selected with these settings. You may not get many wallpapers."
    elsif post_count > 0
      redirect_to edit_link_path(@link), alert: "Only #{post_count} #{'post'.pluralize post_count} can be selected with these settings. You may not get many wallpapers."
    else
      redirect_to edit_link_path(@link), alert: "No posts are selectable with these settings! Check if your theme tag is an aliased tag, or if your blacklist is impossible."
    end
  end

  def assign_e621_post_to_self(e621_post, link)
    link.update(
      {
        post_url: e621_post['file']['url'],
        post_thumbnail_url: e621_post['sample']['url'] || e621_post['preview']['url'],
        post_description: e621_post['description'],
        set_by_id: current_user.nil? ? nil : current_user.id,
        response_type: nil,
        response_text: nil
      }
    )
    link.forks.each do |fork|
      result = get_post e621_post['id'], fork
      assign_e621_post_to_self result, fork if result
    end
    track :regular, :update_set_count, current_user_id: current_user&.id, link_owner_id: link.user.id, current_user_set_count_before_inc: current_user&.set_count
    if current_user.present? && (link.user.id != current_user.id)
      current_user.set_count = current_user.set_count.to_i + 1
      current_user.save
    end
    track :regular, :update_link_post, attempted_post_id: params['link'][:post_id]
    PastLink.log_link(link).save
  end
end
