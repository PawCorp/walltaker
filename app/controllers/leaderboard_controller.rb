class LeaderboardController < ApplicationController
  def index
    @top_setters = User.order(set_count: :desc).limit(10)
  end
end
