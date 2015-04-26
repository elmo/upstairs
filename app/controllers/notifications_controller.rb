class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_notification

  def show
  end

  def destroy
    #@notification.try(:destroy)
    @notification.destroy
    redirect_to :back
  end

  private

  def get_notification
    @notification = Notification.where(user_id: current_user.id, notifiable_id: params[:id]).first
  end

end
