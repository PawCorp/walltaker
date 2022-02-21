class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password
  has_many :link

  validates_uniqueness_of :email, :username

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                              message: 'must be a valid email address' }
  validates :password, confirmation: true
  validates :username, presence: true, format: { with: /\A[a-zA-Z0-9]+\Z/ }
end
