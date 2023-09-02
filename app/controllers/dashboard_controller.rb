class DashboardController < ApplicationController
  after_action :track_visit, only: %i[index]

  def index
    unless current_user.nil?
      @recent_posts = PastLink.order(id: :desc).take 6
      wallpapers_changed_today = PastLink.where(created_at: Time.now.beginning_of_day..Time.now.end_of_day)
      @total_wallpapers_changed_today_by_user = wallpapers_changed_today
                                                        .joins(:user)
                                                        .select('COUNT(DISTINCT past_links.id) as total, users.username')
                                                        .group('users.username')
                                                        .order(total: :desc)
                                                        .limit(20)
      @total_wallpapers_changed_today = wallpapers_changed_today.count
      @total_wallpapers_changed_all = PastLink.count
      @your_total_wallpapers_changed_all = PastLink.where(user_id: current_user.id).count if current_user
      @total_wallpapers_changed_grouped_by_day = PastLink.group_by_day(:created_at, range: 1.weeks.ago.midnight..Time.now).count
      @newest_user = User.last
      @online_links_count = Link.all
                                .where(friends_only: false)
                                .is_online
                                .and(
                                  Link.all.where('expires > ?', Time.now).or(Link.all.where(never_expires: true))
                                ).count

      @users_viewing_links = User.where.not(viewing_link_id: nil)
    end
  end
end
