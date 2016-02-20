class Vendor::AssignmentsController < Vendor::VendorController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy, :complete,:complete, :reopen, :accept, :relinquish]

  def index
    scope = Assignment.assigned_to_user(current_user)
    if params[:building_id]
      @building = Building.find(params[:building_id])
      scope = scope.for_building(@building)
    end
    scope = scope.completed if params[:completed].present? and params[:completed] == 'true'
    scope = scope.open if params[:completed].present? and params[:completed] == 'false'
    scope = scope.accepted(current_user) if params[:accepted].present? and params[:accepted] == 'true'
    scope = scope.waiting_for_claiming(current_user) if params[:accepted].present? and params[:accepted] == 'false'
    @assignments = scope.page(params[:page]).per(10)
  end

  def show
    @comments = @assignment.comments.order(created_at: :asc).page(params[:page]).per(10)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to @assignment, notice: 'Assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete
    @assignment.complete!
    redirect_to :back
  end

  def reopen
    @assignment.reopen!
    redirect_to :back
  end

  def accept
    @assignment.accept!
    redirect_to :back
  end

  def relinquish
    @assignment.relinquish!
    redirect_to :back
  end

  private

    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def set_ticket
      @ticket = Ticket.find(params[:ticket_id])
    end

    def assignment_params
      params.require(:assignment).permit(:user_id, :assigned_to, :ticket_id, :accepted_at, :completed_at)
    end
end
