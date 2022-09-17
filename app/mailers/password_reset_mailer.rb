class PasswordResetMailer < ApplicationMailer
  default :from => 'gray.pup@pawcorp.org'
  
  # @param [User] user
  def reset_password(user)
    @user = user
    @user.password_reset_token = SecureRandom.uuid
    @user.save
    mail( :to => @user.email,
          :subject => 'Walltaker Password Reset' )
  end
end
