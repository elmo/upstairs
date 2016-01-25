class Manage::BuildingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @buildings = current_user.owned_and_managed_properties
  end

end
