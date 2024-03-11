class PasswordResetMailer < ApplicationMailer
  default :from => 'mailgun@walltaker.joi.how'
  
  # @param [User] user
  def reset_password(user)
    @user = user
    @user.password_reset_token = SecureRandom.uuid
    @user.save
    mail( :to => @user.email,
          :subject => 'Walltaker Password Reset' )
  end
end
