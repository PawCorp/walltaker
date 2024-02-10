class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password
  has_many :link
  has_many :past_links, foreign_key: :set_by_id
  has_many :orgasms, foreign_key: :user_id, class_name: 'Nuttracker::Orgasm'
  has_many :caused_orgasms, foreign_key: :caused_by_user_id, class_name: 'Nuttracker::Orgasm'
  has_many :notifications
  has_many :ahoy_visits, :class_name => 'Ahoy::Visit'
  belongs_to :viewing_link, foreign_key: :viewing_link_id, class_name: 'Link', optional: true

  validates_uniqueness_of :username

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                              message: 'must be a valid email address' }
  validates_uniqueness_of :email, :case_sensitive => false
  validates :password, confirmation: true
  validates :username, presence: true, format: { with: /\A[a-zA-Z0-9]+\Z/ }

  enum colour_preference: %i[auto light dark]

  scope :has_friendship_with, ->(other) {
    Friendship.find_friendship(other, self)
  }

  # This was implemented so bad lol, should've been a relation.
  def find_pornlizard
    case mascot
    when 'taylor'
      User.find_by_username('PornLizardTaylor')
    when 'warren'
      User.find_by_username('PornLizardWarren')
    when 'ki'
      User.find_by_username('PornLizardKi')
    else
      User.find_by_username('PornLizardKi')
    end
  end

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
      users_viewing_links = User.where.not(viewing_link_id: nil)
      broadcast_replace_to "link_viewing_users_#{viewed_link.id}", target: "link_viewing_users_#{viewed_link.id}", partial: 'links/viewing_users', locals: { link: viewed_link }
      broadcast_replace_to "dashboard_users_viewing_links", target: "users_viewing_links", partial: 'dashboard/users_viewing_links', locals: { users_viewing_links: }
    end
  end
end
