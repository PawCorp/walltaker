# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authorize, only: %i[index new edit create update destroy]
  before_action :set_link, only: %i[show edit update destroy]

  # GET /links or /links.json
  def index
    @links = User.find(current_user.id).link
  end

  # GET /links/1 or /links/1.json
  def show
    @current_image_post = request_post(@link.currentImage) unless @link.currentImage.nil?
  end

  # GET /links/new
  def new
    @link = Link.new
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
    current_image_post = request_post(link_params[:currentImage]) unless link_params[:currentImage].nil?
    blacklist = @link.blacklist.split(' ') unless @link.blacklist.nil?

    unless blacklist.nil? || current_image_post.nil? || !link_params[:currentImage]
      if (blacklist & current_image_post['post']['tags']['general']).any?
        redirect_to link_url(@link), alert: 'Post was blacklisted.'
        return
      end
    end

    respond_to do |format|
      if @link.update(link_params)
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

  # Only allow a list of trusted parameters through.
  def link_params
    params.require(:link).permit(:expires, :terms, :blacklist, :currentImage)
  end

  def request_post(post_id)
    response = Excon.get(
      "https://e621.net/posts/#{post_id}.json"
    )
    return nil if response.status != 200

    JSON.parse(response.body)
  end
end
