class PastLinksController < ApplicationController
  before_action :past_links_params
  before_action :set_user, only: %i[index]

  def index
    @past_links = PastLink.where(user: @user)
  end

  private

  def set_user
    @user = User.find_by(username: past_links_params[:username])
  end

  def past_links_params
    params.permit(:username)
  end
end
