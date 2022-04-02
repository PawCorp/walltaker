class SessionController < ApplicationController
  after_action :track_visit, only: %i[new]

  def new; end

  def create
    user = User.find_by_email(login_params[:email])
    if !user.nil? && user.authenticate(login_params[:password])
      session[:user_id] = user.id
      ahoy.authenticate(user)
      track :regular, :logged_in
      redirect_to url_for(controller: :dashboard, action: :index), notice: 'Logged in!'
    else
      @error = 'Wrong email or password.'
      track :nefarious, :failed_to_log_in, email: login_params[:email]
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    track :regular, :logged_out
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out!'
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
