class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets
  def index
    @tickets = @community.tickets.page(params[:page]).per(10)
  end

  # GET /tickets/1
  def show
  end

  # GET /tickets/new
  def new
    @ticket = @community.tickets.new(severity: 'Minor', status: 'Open' )
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  def create
    @ticket = @community.tickets.new(ticket_params)
    @ticket.status = 'Open'
    @ticket.user = current_user
    if @ticket.save
      redirect_to community_ticket_path(@community, @ticket), notice: 'Ticket was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tickets/1
  def update
    if @ticket.update(ticket_params)
      redirect_to community_ticket_path(@community, @ticket), notice: 'Ticket was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tickets/1
  def destroy
    @ticket.destroy
    redirect_to community_tickets_path(@community), notice: 'Ticket was successfully updated.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = @community.tickets.find(params[:id])
    end

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end

    # Only allow a trusted parameter "white list" through.
    def ticket_params
      params.require(:ticket).permit(:user_id, :community_id, :title, :body, :severity, :status, photos: [])
    end
end
