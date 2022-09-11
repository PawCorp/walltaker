class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password
  has_many :link
  has_many :notifications
  belongs_to :viewing_link, foreign_key: :id, class_name: 'Link', optional: true

  validates_uniqueness_of :email, :username

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                              message: 'must be a valid email address' }
  validates :password, confirmation: true
  validates :username, presence: true, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  def assign_new_api_key
    self.api_key = SecureRandom.base64(6).slice 0..7
    save
  end

  def view_link(link)
    self.viewing_link_id = link.id
    save
  end

  def leave_link
    self.viewing_link_id = nil
    save
  end

  after_commit do
    if viewing_link_id
      viewed_link = Link.find(viewing_link_id)
    elsif viewing_link_id_before_last_save
      viewed_link = Link.find(viewing_link_id_before_last_save)
    end

    if viewed_link
      broadcast_replace_to "link_viewing_users_#{viewed_link.id}", target: "link_viewing_users_#{viewed_link.id}", partial: 'links/viewing_users', locals: { link: viewed_link }
    end
  end
end
