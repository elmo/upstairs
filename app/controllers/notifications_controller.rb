class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_notification
  layout 'commnity'

  def show
  end

  def destroy
    @notification.destroy
    redirect_to :back
  end

  private

  def get_notification
    @notification = Notification.find(params[:id])
  end
end
