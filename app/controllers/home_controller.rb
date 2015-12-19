class HomeController < ApplicationController
  layout false, only: [:splash]

  def home
    # if current_user.present?
    # redirect_to  current_user.default_building.present? ? building_path(current_user.default_building) : buildings_path
    # elsif current_user.present? and current_user.landlord_or_manager?
    # render template: '/home/home.html.erb'
    # else
    # redirect_to buildings_path
    # end
  end

  def splash
  end
end
