class Api::TicketsController < Api::ApiController
  def index
    @tickets = @building.tickets.page(params[:page]).order(created_at: :desc).per(4)
    render json: @tickets
  end

  def show
    @ticket = @building.tickets.find(params[:id])
    render json: @ticket
  end

  def create
    @ticket = Ticket.create(ticket_params.merge(user_id: current_user.id, building_id: @building.id))
    if @ticket.errors.empty?
      render json: { ticket: TicketSerializer.new(@ticket).serializable_hash }, status: :created
    else
      render json: { errors: @ticket.errors.full_messages }, status: :bad_request
    end
  end

  def update
    @ticket = @building.tickets.find(params[:id])
    if @ticket.update_attributes(ticket_params)
      render json: { ticket: TicketSerializer.new(@ticket).serializable_hash }, status: :ok
    else
      render json: { errors: @ticket.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @ticket = @building.tickets.find(params[:id])
    if @ticket.destroy
      render json: { ticket: TicketSerializer.new(@ticket).serializable_hash }, status: :ok
    else
      render json: { ticket: TicketSerializer.new(@ticket).serializable_hash }, status: :bad_request
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:title, :body, :severity, :status)
  end
end
