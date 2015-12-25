class HomeController < ApplicationController
  layout :get_layout

  def home
  end

  def get_layout
    action_name == 'home' ? 'home' : 'users'
  end

end
