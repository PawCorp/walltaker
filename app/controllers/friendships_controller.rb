class FriendshipsController < ApplicationController
  before_action :authorize, only: %i[index show new edit create update destroy]
  before_action :set_friendship, only: %i[ show edit update destroy ]

  # GET /friendships or /friendships.json
  def index
    @friendships = Friendship.all.where(sender: current_user)
                             .or(Friendship.all.where(receiver: current_user))
  end

  # GET /friendships/1 or /friendships/1.json
  def show
  end

  # GET /friendships/new
  def new
    @receiver_username = params['with'] unless params['with'].nil?
  end

  # GET /friendships/1/edit
  def edit
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
                                                                 receiver_id: receiver.id
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

  # PATCH/PUT /friendships/1 or /friendships/1.json
  def update
    respond_to do |format|
      if @friendship.update(friendship_params)
        format.html { redirect_to friendship_url(@friendship), notice: "Friendship was successfully updated." }
        format.json { render :show, status: :ok, location: @friendship }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1 or /friendships/1.json
  def destroy
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to friendships_url, notice: "Friendship was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friendship_params
      params.require(:friendship).permit(:sender_id, :receiver_id)
    end
end
