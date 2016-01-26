class Manage::EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = current_user.property_events.future
  end

end
