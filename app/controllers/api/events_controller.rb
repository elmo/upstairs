class Api::EventsController < ApplicationController
  before_action :get_building, only: [:index,:show]

  def index
    @events = @building.events.page(params[:page]).order(created_at: :desc).per(4)
    render json: @events
  end

  def show
    @event = @building.events.find(params[:id])
    render json: @event
  end

  private

  def get_building
    @building = Building.friendly.find(params[:building_id])
  end

end
