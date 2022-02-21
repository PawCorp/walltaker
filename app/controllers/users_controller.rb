class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by(username: params[:username])
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

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
