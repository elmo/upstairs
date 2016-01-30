class Manage::ManagerInvitationsController < Manage::ManageController
  before_action :set_manager_invitation, only: [:show, :edit, :update, :destroy]

  # GET /manager_invitations
  # GET /manager_invitations.json
  def index
    @manager_invitations = current_user.manager_invitations.page(params[:page]).per(5)
  end

  # GET /manager_invitations/1
  # GET /manager_invitations/1.json
  def show
  end

  # GET /manager_invitations/new
  def new
    @manager_invitation = current_user.manager_invitations.new
  end

  # GET /manager_invitations/1/edit
  def edit
  end

  # POST /manager_invitations
  # POST /manager_invitations.json
  def create
    @manager_invitation = current_user.manager_invitations.new(manager_invitation_params)

    respond_to do |format|
      if @manager_invitation.save
        format.html { redirect_to manage_manager_invitations_path, notice: 'Manager invitation was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /manager_invitations/1
  # PATCH/PUT /manager_invitations/1.json
  def update
    respond_to do |format|
      if @manager_invitation.update(manager_invitation_params)
        format.html { redirect_to manage_manager_invitation_path(@manager_invitation), notice: 'Manager invitation was successfully updated.' }
        format.json { render :show, status: :ok, location: @manager_invitation }
      else
        format.html { render :edit }
        format.json { render json: @manager_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager_invitations/1
  # DELETE /manager_invitations/1.json
  def destroy
    @manager_invitation.destroy
    respond_to do |format|
      format.html { redirect_to manage_manager_invitations_url, notice: 'Manager invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_manager_invitation
      @manager_invitation = ManagerInvitation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manager_invitation_params
      params.require(:manager_invitation).permit(:email)
    end

end
