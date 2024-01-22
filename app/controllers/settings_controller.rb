class SettingsController < ApplicationController
  before_action :authorize

  def index
    @user = current_user
  end

  def save
    current_user.colour_preference = user_params['colour_preference']

    if current_user.save
      redirect_to user_path(current_user.username), notice: "Settings changed successfully!"
    else
      redirect_to settings_path, notice: "Unknown error occurred"
    end
  end

  def user_params
    params.require(:user).permit(:colour_preference)
  end
end
