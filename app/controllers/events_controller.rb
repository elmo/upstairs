class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  layout 'building'

  # GET /events
  def index
    @event = @building.events.new
    start_date = (params[:start_date].present?) ? Chronic.parse(params[:start_date]) : Date.today.at_beginning_of_month
    if params[:archive] and params[:archive] == 'true'
      @past_or_upcoming_events = 'Past'
      scope = @building.events.where(['starts <= ? ', start_date])
    else
      @past_or_upcoming_events = 'Upcoming Events'
      scope = @building.events.where(['starts >= ?', start_date])
    end

    scope = scope.where(["title like ? or body like ? ", "%#{params[:searchTextField]}%", "%#{params[:searchTextField]}%"]) if params[:searchTextField]
    @search_results_message = "There are no #{@past_or_upcoming_events.downcase} events for this building #{(params[:searchTextField].present?) ? "matching '#{params[:searchTextField]}'." : "" }"
    @events = scope.page(params[:page]).per(5)
    if params[:view] && params[:view] == 'list'
      render template: '/events/list'
    else
      render template: '/events/index'
    end
  end

  # GET /events/1
  def show
    @paginated_comments = @event.comments.where(parent_comment_id: nil).page(params[:comment_page]).per(1)
  end

  # GET /events/new
  def new
    @event = Event.new(user: current_user, building: @building)
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = @building.events.new(event_params)
    @event.user = current_user
    @event.building = @building
    if @event.save
      redirect_to building_events_path(@building), notice: 'Event has been successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to building_events_path(@building), notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end

  # Only allow a trusted parameter "white list" through.
  def event_params
    params.require(:event).permit(:title, :body, :starts, photos: [])
  end
end
