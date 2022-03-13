class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    set_user_vars
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
      redirect_to user_path(@user.username), { notice: 'Successfully updated user.' }
    else
      redirect_to user_path(@user.username), { alert: 'Something went wrong' }
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to url_for(controller: :links, action: :index), notice: 'Thank you for signing up!'
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def set_user_vars
    @user = User.find_by(username: params[:username])
    @has_friendship = Friendship.find_friendship(current_user, @user).exists? if current_user
    @links = @user.link.where(friends_only: false).and(@user.link.where('expires > ?', Time.now).or(@user.link.where(never_expires: true)))
    @any_links_online = @links.where('last_ping > ?', Time.now - 1.minute).count.positive?
    @most_recent_pinged_link = @links.order(last_ping: :desc).take(1) if @links.count.positive?
    @past_links = PastLink.all.order(id: :desc).where(user: @user).take(5)
    @is_current_user = current_user && current_user.id == @user.id
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :details)
  end
end
