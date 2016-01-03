class Api::AlertsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :authenticate_user!
  before_action :get_building, only: [:index, :show, :create, :update,:destroy]

  def index
    @alerts = @building.alerts.page(params[:page]).order(created_at: :desc).per(4)
    render json: @alerts
  end

  def show
    @alert = @building.alerts.find(params[:id])
    render json: @alert
  end

  def create
    @alert = Alert.create(alert_params.merge(user_id: current_user.id, building_id: @building.id))
    if @alert.errors.empty?
      render json: {alert: @alert}, status: :created
    else
      render json: {errors: @alert.errors.full_messages}, status: :bad_request
    end
  end

  def update
    @alert = @building.alerts.find(params[:id])
    if @alert.update_attributes(alert_params)
      render json: {alert: @alert}, status: :ok
    else
      render json: {errors: @alert.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    @alert = @building.alerts.find(params[:id])
    if @alert.destroy
      render json: {alert: @alert}, status: :ok
    else
      render json: {alert: @alert}, status: :bad_request
    end
  end

  private

  def not_found
    render json: {error: 'not found'}, status: :not_found
  end

  def get_building
    @building = Building.friendly.find(params[:building_id])
  end

  def alert_params
    params.require(:alert).permit(:message)
  end

end
