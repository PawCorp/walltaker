class UsersController < ApplicationController
  after_action :track_visit, only: %i[new show edit]
  before_action :authorize, only: %i[update]

  def new
    @user = User.new
  end

  def show
    set_user_vars
    @total_orgasms_by_day = @user.orgasms.where('created_at > ?', 1.weeks.ago.midnight).group_by_day(:created_at, range: 1.weeks.ago.midnight..Time.now).count
    @total_orgasms_caused = @user.caused_orgasms.where('caused_by_user_id <> user_id').count unless @user.username == 'gray'
    @total_orgasms_caused = Nuttracker::Orgasm.count if @user.username == 'gray'
  end

  def sets
    @user = User.find_by(username: params[:username])
    @past_links = PastLink.where(set_by_id: @user.id).order(id: :desc).limit(50)
  end

  def edit
    set_user_vars
    @is_editing = true
    return redirect_to user_path(@user.username) unless @is_current_user

    render 'users/show'
  end

  def update
    @user = User.find(params[:id])
    return redirect_to user_path(@user.username), { alert: 'Not Authorized.' } if current_user.id != @user.id

    @user.details = user_params[:details]
    if @user.save
      track :regular, :updated_details

      if @user.current_surrender
        Notification.create user: @user, notification_type: :surrender_event, link: user_path(@user.username), text: "#{@user.current_surrender.controller.username} changed a profile setting."
      end
      redirect_to user_path(@user.username), { notice: 'Successfully updated user.' }
    else
      track :error, :updating_details_went_wrong
      redirect_to user_path(@user.username), { alert: 'Something went wrong' }
    end
  end

  def create
    if current_visit&.banned_ip.present?
      return
    end

    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      track :regular, :signed_up_and_first_log_in
      ahoy.authenticate(@user)
      redirect_to url_for(controller: :links, action: :index), notice: 'Thank you for signing up!'
    else
      track :error, :failed_to_sign_up, errors: @user.errors
      render 'new', status: :unprocessable_entity
    end
  end

  def request_password_reset

  end
  def password_reset
    begin
      user = User.where("lower(email) = ?", params[:email]&.downcase).first

      unless user
        throw :nefarious
      end

      PasswordResetMailer.reset_password(user).deliver
      redirect_to login_path, notice: 'A password reset email has been sent to that user'
    rescue
      track :nefarious, :failed_to_reset_password, tried_email: params['email'], exception: $!
      redirect_to forgor_path, alert: 'User was not found with that email'
    end
  end

  def apply_new_password

  end

  def commit_apply_new_password
    user = User.find_by(password_reset_token: params['password_reset_token'])

    if user && params['password'] && params['password_confirmation'] && (params['password'] == params['password_confirmation'])
      user.password = params['password']
      user.password_confirmation = params['password_confirmation']
      user.password_reset_token = nil
      result = user.save

      if result
        return redirect_to login_path, notice: 'Password reset successfully!'
      end
    end

    redirect_to forgor_apply_path(params['password_reset_token']), alert: 'Something went wrong, try again. Ensure the password confirmation was typed correctly.'
  end

  def new_api_key
    @user = User.find_by(username: params[:username])
    if (@user.id == current_user.id)
      @user.assign_new_api_key
    end
    redirect_to user_path(@user.username)
  end

  private

  def set_user_vars
    @user = User.find_by(username: params[:username])
    @has_friendship = Friendship.find_friendship(current_user, @user).exists? if current_user
    @links = @user.link.where(friends_only: false).and(@user.link.where('expires > ?', Time.now).or(@user.link.where(never_expires: true))) unless @has_friendship
    @links = @user.link.where('expires > ?', Time.now).or(@user.link.where(never_expires: true)) if @has_friendship
    @any_links_online = @links.is_online.count.positive?
    @most_recent_pinged_link = @links.order(last_ping: :desc).take(1) if @links.count.positive?
    @past_links = PastLink.all.order(id: :desc).where(user: @user).take(5)
    @is_current_user = current_user && current_user.id == @user.id
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :details)
  end
end
