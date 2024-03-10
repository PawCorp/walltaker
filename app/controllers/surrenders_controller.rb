class SurrendersController < ApplicationController
  before_action :authorize
  before_action :set_friendship_options, only: %i[new edit]
  before_action :set_surrender, only: %i[show edit destroy]
  before_action :protect_own_surrender, only: %i[show destroy]

  def index
    @current_surrender = current_user.current_surrender
  end

  def show
  end

  def create
    friendship = Friendship.involving(current_user).is_confirmed.find(surrender_params[:friendship])

    if friendship.present?
      surrender = current_user.create_current_surrender(expires_at: Time.now + 24.hours, friendship:)

      if surrender.save
        redirect_to surrender_path(surrender), notice: 'Surrender was successfully created. Now just wait...'
      else
        redirect_to new_surrender_path, alert: surrender.errors.full_messages.first
      end
    else
      redirect_to new_surrender_path, alert: 'Friendship does not exist.'
    end
  end

  def new
    @surrender = Surrender.new
  end

  def destroy
    if @surrender.destroy
      redirect_to surrenders_path, notice: 'Surrender was successfully destroyed.'
    else
      redirect_to surrender_path(@surrender), alert: 'Surrender could not be destroyed.'
    end
  end

  private

  def set_friendship_options
    friendships = Friendship.involving(current_user).is_confirmed
    @friendship_options = friendships.map { |f| [f.other_user(current_user).username, f.id] }
  end

  def set_surrender
    @surrender = Surrender.find(params[:id])
  end

  def surrender_params
    params.require(:surrender).permit(:friendship)
  end

  def protect_own_surrender
    redirect_to surrenders_path, alert: 'You cannot configure this surrender.' if @surrender.user != current_user
  end
end
