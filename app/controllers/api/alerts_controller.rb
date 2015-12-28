class Api::AlertsController < ApplicationController
  before_action :get_building, only: [:index, :show]

  def index
    @alerts = @building.alerts.page(params[:page]).order(created_at: :desc).per(4)
    render json: @alerts
  end

  def show
    @alert = @building.alerts.find(params[:id])
    render json: @alert
  end

  private

  def get_building
    @building = Building.friendly.find(params[:building_id])
  end


end
