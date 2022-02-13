# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authorize, only: %i[index new edit create destroy]
  after_action :log_presence, only: %i[show]
  before_action :set_link, only: %i[show edit update destroy]
  before_action :prevent_public_expired, only: %i[show update]

  # GET /links or /links.json
  def index
    @links = User.find(current_user.id).link
  end

  # GET /links/1 or /links/1.json
  def show; end

  # GET /links/new
  def new
    @link = Link.new
    @link.expires = Time.now + 1.days
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
    if (current_user && ((current_user.id != @link.user.id) && !link_params.empty?)) || (current_user.nil? && !link_params.empty?)
      redirect_to link_url(@link), alert: 'Not authorized.'
      return
    end
    current_image_post = request_post(params['link'][:post_id]) unless params['link'][:post_id].nil?
    blacklist = @link.blacklist.split(' ') unless @link.blacklist.nil?

    unless blacklist.nil? || current_image_post.nil?
      if (blacklist & current_image_post['post']['tags']['general']).any?
        redirect_to link_url(@link), alert: 'Post was blacklisted.'
        return
      end
    end

    result = if (current_image_post.nil?)
               @link.update(link_params)
             else
               @link.update(HashWithIndifferentAccess.new({
                                                            post_url: current_image_post['post']['file']['url'],
                                                            post_thumbnail_url: current_image_post['post']['preview']['url'],
                                                            post_description: current_image_post['post']['description']
                                                          }).merge(link_params))
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.find(params[:id])
  end

  def prevent_public_expired
    @is_expired = @link.expires <= Time.now

    redirect_to root_url, alert: 'That link was expired!' if @is_expired && current_user.id != @link.user.id
  end

  # Only allow a list of trusted parameters through.
  def link_params
    params.require(:link).permit(:expires, :terms, :blacklist)
  end

  def request_post(post_id)
    response = Excon.get(
      "https://e621.net/posts/#{post_id.to_i}.json"
    )
    return nil if response.status != 200

    JSON.parse(response.body)
  end

  def log_presence
    if request.format == :json
      @link.last_ping = Time.now
      @link.save
    end
  end
end
