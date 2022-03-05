class DashboardController < ApplicationController
  def index
    unless (current_user.nil?)
      @recent_posts = PastLink.order(id: :desc).take 6
      @wallpapers_changed_today = PastLink.where(created_at: Time.now.beginning_of_day..Time.now.end_of_day)
                                          .joins(:user)
                                          .select('COUNT(DISTINCT past_links.id) as total, users.username')
                                          .group('users.username')
                                          .order(total: :desc)
      @online_links_count = Link.all
                                .where(friends_only: false)
                                .where('last_ping > ?', Time.now - 1.minute)
                                .and(
                                  Link.all.where('expires > ?', Time.now).or(Link.all.where(never_expires: true))
                                ).count
    end
  end
end
