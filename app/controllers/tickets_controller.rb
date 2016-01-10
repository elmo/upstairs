class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building
  before_action :set_ticket, only: [:show, :edit, :update, :destroy,:open,:close,:escalate,:deescalate]
  layout 'building'

  # GET /tickets
  def index
    scope = @building.tickets
    scope = scope.open if params[:status] == Ticket::STATUS_OPEN
    scope = scope.closed if params[:status] == Ticket::STATUS_CLOSED
    scope = scope.severe if params[:severity] == Ticket::SEVERITY_SEVERE
    scope = scope.serious if params[:severity] == Ticket::SEVERITY_SERIOUS
    scope = scope.minor if params[:severity] == Ticket::SEVERITY_MINOR
    scope = scope.where(["title like ? or body like ? ", "%#{params[:searchTextField]}%", "%#{params[:searchTextField]}%"]) if params[:searchTextField]
    @tickets = scope.page(params[:page]).order(severity: :desc).page(params[:page]).per(5)
  end

  # GET /tickets/1
  def show
    @paginated_comments = @ticket.comments.where(parent_comment_id: nil).page(params[:comment_page]).per(1)
  end

  # GET /tickets/new
  def new
    @ticket = @building.tickets.new(severity: Ticket::SEVERITY_MINOR, status: Ticket::STATUS_OPEN)
  end

  # GET /tickets/1/edit
  def edit
  end

  # PUT /tickets/1/open
  def open
    @ticket.open!
    redirect_to :back
  end

  # PUT /tickets/1/close
  def close
    @ticket.close!
    redirect_to :back
  end

  # PUT /tickets/1/escalate
  def escalate
    @ticket.escalate!
    redirect_to :back
  end

  # PUT /tickets/1/deescalate
  def deescalate
    @ticket.deescalate!
    redirect_to :back
  end

  # POST /tickets
  def create
    @ticket = @building.tickets.new(ticket_params)
    @ticket.status = 'Open'
    @ticket.user = current_user
    if @ticket.save
      redirect_to building_ticket_path(@building, @ticket), notice: 'Ticket was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tickets/1
  def update
    if @ticket.update(ticket_params)
      redirect_to building_ticket_path(@building, @ticket), notice: 'Ticket was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tickets/1
  def destroy
    @ticket.destroy
    redirect_to building_tickets_path(@building), notice: 'Ticket was successfully updated.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = @building.tickets.find(params[:id])
  end

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end

  # Only allow a trusted parameter "white list" through.
  def ticket_params
    params.require(:ticket).permit(:user_id, :building_id, :title, :body, :severity, :status, photos: [])
  end
end
