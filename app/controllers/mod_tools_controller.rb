class ModToolsController < ApplicationController
  before_action :authorize_with_admin

  def index
  end

  def show_password_reset
  end

  def update_password_reset
    email = params.permit(:email)['email']

    if !email || email.length < 2
      return redirect_to mod_tools_passwords_index_path(fail: 'Email segment too short. Ideally at least 6 letters. They need to provide more of their email.', email:)
    end

    # Prepared statement, rails escapes and wraps template var here.
    matches = User.where('lower(email) LIKE ?', "%#{email.downcase}%").all if params['commit'] == 'Try to generate a reset link (case insensitive)'
    matches = User.where('email LIKE ?', "%#{email}%").all if params['commit'] == 'Try to generate a reset link (case sensitive)'

    if matches.length > 1
      if matches.length == 2 && (matches[0].email.downcase === matches[1].email.downcase)
        return redirect_to mod_tools_passwords_index_path(fail: "Found 2 accounts only differing by capitalization, #{matches[0].email} and #{matches[1].email}. Use case sensitive search.", email:)
      else
        return redirect_to mod_tools_passwords_index_path(fail: 'Matches more than 1 account, can they be more specific?', email:)
      end
    end

    if !matches || matches.length == 0
      return redirect_to mod_tools_passwords_index_path(fail: 'Email does not exist in database, did they make a typo?', email:)
    end

    matches[0].password_reset_token = SecureRandom.uuid + '-' + current_user.id.to_s
    matches[0].save

    track :regular, :mod_password_reset, by: current_user.username, for: matches[0].username

    if email.length < 6
      return redirect_to mod_tools_passwords_index_path(link: matches[0].password_reset_token, username: matches[0].username, fail: "Search provided was short. (Only #{email.length} letters!) Are you sure you aren\'t being manipulated? Someone may be able to guess a small portion of an email.", email: matches[0].email)
    end

    redirect_to mod_tools_passwords_index_path(link: matches[0].password_reset_token, username: matches[0].username, email: matches[0].email)
  end

  def show_user
    if params['email']
      email = params.permit(:email)['email']
      user = User.where('lower(email) LIKE ?', "%#{email.downcase}%").first

      render 'show_user', locals: { user: }
    end
  end

  def update_user
    begin
      safe_params = params.require(:user).permit(:id, :email, :username, :details, :api_key, :set_count, :viewing_link, :password_reset_token, :quarantined, :pervert, :mascot)
      user = User.find(safe_params['id'])

      if user
        user.update(safe_params)
        return render turbo_stream: turbo_stream.replace("mod_tools_edit_user_form", partial: 'mod_tools/edit_user_form', locals: { user: })
      end
    rescue
      return render turbo_stream: turbo_stream.replace("mod_tools_edit_user_form", partial: 'mod_tools/edit_user_form', locals: { fail: 'something went wrong' })
    end

    render turbo_stream: turbo_stream.replace("mod_tools_edit_user_form", partial: 'mod_tools/edit_user_form', locals: { fail: 'that user does not exist' })
  end

  def show_quarantine
    @users = User.where(admin: false).order(id: :desc).limit 100
  end

  def update_quarantine
    user = User.find(params['user'])

    unless user
      redirect_to mod_tools_quarantine_index_path, alert: 'Failed to find that user.'
      return
    end

    user.quarantined = user.quarantined ? false : true
    result = user.save

    redirect_to mod_tools_quarantine_index_path(anchor: helpers.dom_id(user))
  end

  def update_ipban
    user = User.find(params['user'])

    unless user
      redirect_to mod_tools_quarantine_index_path, alert: 'Failed to find that user.'
      return
    end

    ips = user.ahoy_visits.all.map {|visit| visit.ip}
    ips.each do |ip|
      BannedIp.create(ip_address: ip, banned_by: current_user)
    end

    redirect_to mod_tools_quarantine_index_path(anchor: helpers.dom_id(user))
  end
end
