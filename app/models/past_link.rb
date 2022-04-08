class PastLink < ApplicationRecord
  belongs_to :link
  belongs_to :user
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
  end
end
