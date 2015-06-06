class HomeController < ApplicationController
  layout false, only: [:splash]

  def home
    if current_user.present?
     redirect_to  current_user.default_community.present? ? community_path(current_user.default_community) : communities_path
    elsif current_user.present? and current_user.landlord_or_manager?
     render template: '/home/home.html.erb'
    else
     redirect_to communities_path
    end
  end

  def splash
  end

end
