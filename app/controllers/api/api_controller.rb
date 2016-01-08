class Api::ApiController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :authenticate_user!
  before_action :get_building, only: [:index, :show, :create, :update,:destroy,:calendar]

  private

  def not_found
    render json: {error: 'not found'}, status: :not_found
  end

  def get_building
    @building = Building.friendly.find(params[:building_id])
  end

end
