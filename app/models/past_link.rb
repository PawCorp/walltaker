class PastLink < ApplicationRecord
  belongs_to :link
  belongs_to :user
  #belongs_to :set_by_user, foreign_key: 'set_by_id', class_name: 'User'
  visitable :ahoy_visit

  def self.log_link(link)
    new({
          link:,
          user: link.user,
          post_url: link.post_url,
          post_thumbnail_url: link.post_thumbnail_url,
          set_by_id: link.set_by_id
        })
  end

  after_commit do
    broadcast_replace_to "link_details_#{link_id}", target: "link_details_#{link_id}", partial: 'links/details', locals: { link: self.link }
    broadcast_replace_to "dashboard_recent_posts", target: "recent_posts", partial: "dashboard/recent_posts", locals: {
      recent_posts: PastLink.order(id: :desc).take(6)
    }
  end
end
