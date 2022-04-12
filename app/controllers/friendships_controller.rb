class FriendshipsController < ApplicationController
  before_action :authorize, only: %i[index show new edit create update accept destroy]
  before_action :set_friendship, only: %i[show edit update accept destroy]
  after_action :track_visit, only: %i[index requests show new]

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

      track :regular, :accepted_friend_request, sender_id: @friendship.sender_id, receiver_id: @friendship.receiver_id, friendship_id: @friendship.id
      Notification.create user: @friendship.sender, notification_type: :friend_request_they_accepted, text: "#{@friendship.receiver.username} accepted your friend request.", link: "/users/#{@friendship.receiver.username}"

      redirect_to url_for(controller: :friendships, action: :index), notice: 'Friendship Accepted!'
      return
    end

    track :nefarious, :tried_to_accept_others_friend_request, sender_id: @friendship.sender_id, receiver_id: @friendship.receiver_id, friendship_id: @friendship.id

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
      track :regular, :sent_friend_request, sender_id: @friendship.sender_id, receiver_id: @friendship.receiver_id, friendship_id: @friendship.id
      Notification.create user: @friendship.sender, notification_type: :friend_request_sent, text: "You sent a friend request to #{@friendship.receiver.username}.", link: "/users/#{@friendship.receiver.username}"
      Notification.create user: @friendship.receiver, notification_type: :friend_request_received, text: "#{@friendship.sender.username} sent you a friend request.", link: "/friendships/requests"
      redirect_back_or_to root_path, notice: 'Friend request sent!'
    else
      track :error, :failed_to_send_friend_request, errors: @friendship.errors, receiver_username: params['receiver_username']
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /friendships/1 or /friendships/1.json
  def destroy
    unless @friendship.receiver_id != current_user.id || @friendship.sender_id != current_user.id
      track :nefarious, :tried_to_delete_others_friend_request, sender_id: @friendship.sender_id, receiver_id: @friendship.receiver_id, friendship_id: @friendship.id
      redirect_to root_url, alert: 'Not Authorized'
      return
    end

    track :regular, :deleted_friend_request, sender_id: @friendship.sender_id, receiver_id: @friendship.receiver_id, friendship_id: @friendship.id

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
