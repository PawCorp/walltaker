class PastLinksController < ApplicationController
  before_action :past_links_params
  before_action :set_user, only: %i[index]

  def index
    # I'm so sorry, this is going to be HORRIBLE for performance. Capping at 50 to avoid loading up Enumerable#group_by too much
    @past_links_by_user = PastLink.where(user: @user).take(50).group_by(&:set_by_id).map do |set_by_id, past_links|
      {
        past_links:,
        set_by: set_by_id.nil? ? nil : User.find(set_by_id)
      }
    end
  end

  private

  def set_user
    @user = User.find_by(username: past_links_params[:username])
  end

  def past_links_params
    params.permit(:username)
  end
end
