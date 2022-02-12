class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password

  validates_uniqueness_of :email, :username

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                              message: 'must be a valid email address' }
  validates :password, confirmation: true
  validates :username, presence: true
end
