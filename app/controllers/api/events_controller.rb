class Api::EventsController < Api::ApiController

  def index
    @events = @building.events.page(params[:page]).order(created_at: :desc).per(4)
    render json: @events
  end

  def calendar
    scope = @building.events
    params[:start] ||= (Date.today - 1.week).strftime("%Y-%m-%d")
    params[:end] ||= (Date.today + 5.weeks).strftime("%Y-%m-%d")
    scope = scope.where(["starts >= ? and starts < ? ", params[:start], params[:end] ])
    @events = scope.order(created_at: :desc)
  end

  def show
    @event = @building.events.find(params[:id])
    render json: @event
  end

  def create
    @event = Event.create(event_params.merge(user_id: current_user.id, building_id: @building.id))
    if @event.errors.empty?
      render json: {event: EventSerializer.new(@event).serializable_hash}, status: :created
    else
      render json: {errors: @event.errors.full_messages}, status: :bad_request
    end
  end

  def update
    @event = @building.events.find(params[:id])
    if @event.update_attributes(event_params)
      render json: {event: EventSerializer.new(@event).serializable_hash}, status: :ok
    else
      render json: {errors: @event.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    @event = @building.events.find(params[:id])
    if @event.destroy
      render json: {event: EventSerializer.new(@event).serializable_hash}, status: :ok
    else
      render json: {event: EventSerializer.new(@event).serializable_hash}, status: :bad_request
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :body, :starts)
  end

end
