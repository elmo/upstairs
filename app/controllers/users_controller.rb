class UsersController < ApplicationController
  layout :get_layout
  before_action :authenticate_user!
  before_action :get_building, only: [:show]

  def home
  end

  def show
    @user = User.where(slug: params[:id]).last
    if @user.landlord?
      render template: '/users/landlord'
    else
      render template: '/users/show'
    end
  end

  private

  def get_building
    @building = Building.friendly.find(params[:building_id])
  end

  def get_layout
    'building'
  end

end
