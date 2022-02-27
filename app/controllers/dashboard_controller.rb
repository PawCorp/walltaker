class DashboardController < ApplicationController
  def index
    @online_links_count = Link.all
                              .where(friends_only: false)
                              .where('last_ping > ?', Time.now - 1.minute)
                              .and(
                                Link.all.where('expires > ?', Time.now).or(Link.all.where(never_expires: true))
                              ).count
  end
end
