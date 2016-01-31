class Manage::InvitationsController < Manage::ManageController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  layout 'building'

  # GET /invitations
  def index
    scope = current_user.invitations
    scope = scope.where(['message like ? ', "%#{params[:searchTextField]}%"]) if params[:searchTextField]
    @invitations = scope.order('created_at desc').page(params[:page]).per(10)
  end

  # GET /invitations/1
  def show
  end

  # GET /invitations/new
  def new
    @invitation = @building.invitations.new(user: current_user)
  end

  # GET /invitations/1/edit
  def edit
    @invitation = @building.invitations.find(params[:id])
  end

  # POST /invitations
  def create
    @invitation = @building.invitations.new(invitation_params)
    @invitation.user = current_user

    if @invitation.save
      redirect_to building_invitations_path(@building), notice: 'Invitation was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /invitations/1
  def update
    if @invitation.update(invitation_params)
      redirect_to building_invitations_path(@building), notice: 'Invitation was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /invitations/1
  def destroy
    @invitation.destroy
    redirect_to building_invitations_url(@building), notice: 'Invitation was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def invitation_params
    params[:invitation].permit(:message)
  end
end
