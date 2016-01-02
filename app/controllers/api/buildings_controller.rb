class Api::BuildingsController < ApplicationController

  def show
    @building = (params[:id] =~ /\D/) ? Building.find_by_slug(params[:id]) : Building.find(params[:id])
    render json: @building
  end

end
