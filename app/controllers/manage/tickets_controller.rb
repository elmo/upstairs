class Manage::TicketsController < Manage::ManageController
   before_action :set_ticket, only: [:show, :edit, :update, :destroy]
   before_action :set_building, only: [:new]

  def index
    scope = Ticket.managed_by(current_user)
    scope = scope.open if params[:status] == Ticket::STATUS_OPEN
    scope = scope.closed if params[:status] == Ticket::STATUS_CLOSED
    scope = scope.severe if params[:severity] == Ticket::SEVERITY_SEVERE
    scope = scope.serious if params[:severity] == Ticket::SEVERITY_SERIOUS
    scope = scope.minor if params[:severity] == Ticket::SEVERITY_MINOR
    scope = scope.where(['title like ? or body like ? ', "%#{params[:searchTextField]}%", "%#{params[:searchTextField]}%"]) if params[:searchTextField]
    if params[:user_id]
      @user = User.find_by(slug: params[:user_id] )
      scope = scope.where(user_id: @user.id)
    end

    if params[:building_id]
      @building = Building.find_by(slug: params[:user_id] )
      scope = scope.where(building_id: @building.id)
    end

    @tickets = scope.page(params[:page]).order(severity: :desc).page(params[:page]).per(5)
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def new
    @ticket = Ticket.new(building: @building, user: current_user, status: Ticket::STATUS_OPEN, severity: Ticket::SEVERITY_SERIOUS )
  end

  def edit
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user_id = current_user
    @ticket.status = Ticket::STATUS_OPEN
    @ticket.user = current_user
    if @ticket.save
      redirect_to manage_ticket_path(@ticket), notice: 'Ticket was successfully created.'
    else
      render :new
    end
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to manage_ticket_path(@ticket), notice: 'Ticket was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_ticket
    @ticket = Ticket.managed_by(current_user).find(params[:id])
  end

  def set_building
    if params[:building_id].present?
      @building = Building.friendly.find(params[:building_id])
      return
    end
    @building = current_user.owned_and_managed_properties.first
  end

  def ticket_params
    params[:ticket].permit(:title, :body, :building_id, :severity, :status, photos: [])
  end

end
