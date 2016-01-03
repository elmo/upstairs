class Api::TicketsController < ApplicationController
  before_action :get_building, only: [:index,:show]

  def index
    @tickets = @building.tickets.page(params[:page]).order(created_at: :desc).per(4)
    render json: @tickets
  end

  def show
    @ticket = @building.tickets.find(params[:id])
    render json: @ticket
  end

  private

  def get_building
    @building = Building.friendly.find(params[:building_id])
  end

end
