class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:redeem, :welcome]
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  before_action :set_building, except:  [:welcome]
  layout 'building'


  # GET /invitations/1
  def show
  end

  def welcome
    # user has shared static link for this building
    @building = Building.where(invitation_link: params[:id] ).first
    if @building.present?
      session[:invitation_link] = params[:id]
      redirect_to building_path(@building)
    else
      not_found
    end

  end

  def redeem
    @invitation = @building.invitations.where(token: params[:invitation_id]).first
    session[:invitation_code]  = @invitation.token
    user = User.find_by_email(@invitation.email)
    redirect_to (user.present?) ? new_user_session_path : join_path
  end

  # GET /invitations/new
  def new
    @invitation = Invitation.new
    @invitation.type = params[:type] || 'UserInvitation'
  end

  # POST /invitations
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = current_user
    @invitation.building = @building

    if @invitation.save
      redirect_to @invitation.building, notice: 'Invitation was successfully created.'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find_by(token: params[:id])
    end

    def set_building
      @building = Building.friendly.find(params[:building_id])
    end

    # Only allow a trusted parameter "white list" through.
    def invitation_params
      params.require(:invitation).permit(:user_id, :building_id, :token, :email, :redeemed_at, :type)
    end
end
