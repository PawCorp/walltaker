class NotificationController < ApplicationController
  before_action :set_notification, only: %i[show]
  #before_action :authorize

  def show
    if @notification && (@notification.user.id == current_user.id)
      link = @notification.link
      if @notification.delete
        track :regular, :notification_click, link: link
        redirect_to link
      else
        track :error, :notification_not_found, link: link
      end
    else
      track :nefarious, :tried_to_read_others_notification, logged_in_as: current_user, notification: @notification
    end
  end

  def delete_all
    @notifications = current_user.notifications
    if @notifications.destroy_all
      redirect_back fallback_location: root_path
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
