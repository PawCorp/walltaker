class FriendshipsController < ApplicationController
  before_action :authorize, only: %i[index show new edit create update accept destroy]
  before_action :set_friendship, only: %i[show edit update accept destroy]

  # GET /friendships or /friendships.json
  def index
    @friendships = Friendship.all.where(sender: current_user)
                             .or(Friendship.all.where(receiver: current_user))
                             .where(confirmed: true)
  end

  # GET /friendship/requests
  def requests
    @friendships = Friendship.all.where(receiver: current_user)
                             .where(confirmed: [nil, false])
    render :index
  end

  # GET /friendships/1 or /friendships/1.json
  def show; end

  # GET /friendships/new
  def new
    @receiver_username = params['with'] unless params['with'].nil?
  end

  # PUT /friendships/1/accept
  def accept
    if @friendship.receiver_id == current_user.id
      @friendship.confirmed = true
      @friendship.save

      redirect_to url_for(controller: :friendships, action: :index), notice: 'Friendship Accepted!'
      return
    end

    redirect_to root_url, alert: 'Not Authorized'
  end

  # POST /friendships or /friendships.json
  def create
    receiver = User.find_by username: params['receiver_username']
    if receiver.nil?
      redirect_back_or_to root_path, alert: 'User was not found.'
      return
    end

    @friendship = Friendship.new(HashWithIndifferentAccess.new({
                                                                 sender_id: current_user.id,
                                                                 receiver_id: receiver.id,
                                                                 confirmed: false
                                                               }))

    unless @friendship.valid?
      redirect_back_or_to root_path, alert: 'You\'re already friends, or have a pending request.'
      return
    end

    if @friendship.save
      redirect_back_or_to root_path, notice: 'Friend request sent!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /friendships/1 or /friendships/1.json
  def destroy
    unless @friendship.receiver_id != current_user.id || @friendship.sender_id != current_user.id
      redirect_to root_url, alert: 'Not Authorized'
      return
    end

    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to friendships_url, notice: "Friendship was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
