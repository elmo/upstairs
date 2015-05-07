class InvitationsController < ApplicationController
  #before_action :authenticate_user!, except: :redeem
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  before_action :set_community
  layout 'community'

  # GET /invitations/1
  def show
  end

  def redeem
    @invitation = @community.invitations.where(token: params[:invitation_id]).first
    redirect_to join_path(invitation_id: @invitation.token)
  end

  # GET /invitations/new
  def new
    @invitation = Invitation.new
  end

  # POST /invitations
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = current_user
    @invitation.community = @community

    if @invitation.save
      redirect_to @invitation, notice: 'Invitation was successfully created.'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end

    # Only allow a trusted parameter "white list" through.
    def invitation_params
      params.require(:invitation).permit(:user_id, :community_id, :token, :email, :redeemed_at)
    end
end