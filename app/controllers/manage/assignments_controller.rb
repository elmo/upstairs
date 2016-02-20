class Manage::AssignmentsController < Manage::ManageController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy, :complete,:complete, :reopen, :accept, :relinquish]
  before_action :set_ticket, only: [:new, :create]

  # GET /manage/assignments
  # GET /manage/assignments.json
  def index
    if params[:user_id].present?
      @user = User.find_by_slug(params[:user_id])
      scope = Assignment.assigned_to_user(@user)
    else
      scope = current_user.assignments
    end
    @assignments = scope.page(params[:page]).per(10)
  end

  # GET /manage/assignments/new
  def new
    @assignment = Assignment.new(ticket: @ticket)
  end

  def show
    @comments = @assignment.comments.order(created_at: :asc).page(params[:page]).per(10)
  end

  # GET /manage/assignments/1/edit
  def edit
   @ticket = @assignment.ticket
  end

  # POST /manage/assignments
  # POST /manage/assignments.json
  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.user = current_user
    respond_to do |format|
      if @assignment.save
        format.html { redirect_to manage_tickets_path, notice: 'Assignment was successfully created.' }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/assignments/1
  # PATCH/PUT /manage/assignments/1.json
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


  # DELETE /manage/assignments/1
  # DELETE /manage/assignments/1.json
  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def set_ticket
      @ticket = Ticket.find(params[:ticket_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:user_id, :assigned_to, :ticket_id, :accepted_at, :completed_at)
    end
end
