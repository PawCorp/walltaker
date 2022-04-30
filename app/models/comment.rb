class Comment < ApplicationRecord
  belongs_to :link
  belongs_to :user
  validates :content, presence: true

  after_commit do
    broadcast_prepend_to "link_comments_#{link.id}", target: "link_comments", partial: 'comments/comment', locals: { comment: self }
  end
end
