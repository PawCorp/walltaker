class LeaderboardController < ApplicationController
  def index
    @top_setters = User.where.not(username: %w[PornLizardKi PornLizardWarren PornLizardTaylor PornBot]).order(set_count: :desc).limit(10)
  end
end
