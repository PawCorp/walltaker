class PastLink < ApplicationRecord
  belongs_to :link
  belongs_to :user

  def self.log_link(link)
    new({
          link:,
          user: link.user,
          post_url: link.post_url,
          post_thumbnail_url: link.post_thumbnail_url,
          set_by_id: link.set_by_id
        })
  end
end
