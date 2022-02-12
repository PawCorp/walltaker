class SessionController < ApplicationController
  def new; end

  def create
    user = User.find_by_email(login_params[:email])
    if !user.nil? && user.authenticate(login_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in!'
    else
      @error = 'Wrong email or password.'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out!'
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
