# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :port => ENV['MAILGUN_SMTP_PORT'],
  :address => ENV['MAILGUN_SMTP_SERVER'],
  :user_name => ENV['MAILGUN_SMTP_LOGIN'],
  :password => ENV['MAILGUN_SMTP_PASSWORD'],
  :domain => 'walltaker.joi.how',
  :authentication => :plain
}
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
