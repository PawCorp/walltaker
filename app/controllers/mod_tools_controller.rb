class ModToolsController < ApplicationController
  before_action :authorize_with_admin

  def index
  end

  def show_password_reset
  end

  def update_password_reset
    email = params.permit(:email)['email']

    if !email || email.length < 6
      return redirect_to mod_tools_passwords_index_path(fail: 'Email segment too short. Must be at least 6 letters. They need to provide more of their email.', email:)
    end

    # Prepared statement, rails escapes and wraps template var here.
    matches = User.where('email LIKE ?', "%#{email}%").all

    if matches.length > 1
      return redirect_to mod_tools_passwords_index_path(fail: 'Matches more than 1 account, can they be more specific?', email:)
    end

    if !matches || matches.length == 0
      return redirect_to mod_tools_passwords_index_path(fail: 'Email does not exist in database, did they make a typo?', email:)
    end

    matches[0].password_reset_token = SecureRandom.uuid
    matches[0].save
    redirect_to mod_tools_passwords_index_path(link: matches[0].password_reset_token, username: matches[0].username, email:)
  end

  def show_user
  end

  def destroy_user
  end
end
