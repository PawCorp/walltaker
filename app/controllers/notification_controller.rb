class NotificationController < ApplicationController
  before_action :set_notification

  def show
    if @notification
      link = @notification.link
      if @notification.delete
        track :regular, :notification_click, link: link
        redirect_to link
      else
        track :error, :notification_not_found, link: link
      end
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
