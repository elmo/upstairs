class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  layout 'community'

  # GET /events
  def index
    start_date = ( params[:start_date].present?) ? Chronic.parse( params[:start_date]) : Date.today
    @events = @community.events.where(["starts >= ? and starts < ?", start_date, start_date.next_month ])
    if params[:view] and  params[:view]  == 'list'
      render template: "/events/list"
    else
      render template: "/events/index"
    end
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = Event.new(user: current_user, community: @community )
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = @community.events.new(event_params)
    @event.user = current_user
    @event.community = @community
    if @event.save
      redirect_to community_events_path(@community), notice: "Event has been successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
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

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:title, :body, :starts)
    end
end
