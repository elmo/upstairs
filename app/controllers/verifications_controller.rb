class VerificationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_verification_request, except: [:index, :destroy]
  before_action :set_verification, only: [:show, :edit, :update]

  # GET /verifications
  def index
    @verifications = Verification.page(params[:page]).per(10)
  end

  def new
    @verification = Verification.new(
      verification_request_id: @verification_request.id,
      user_id: @verification_request.user_id,
      building_id: @verification_request.building_id
    )
  end

  # POST /verifications
  def create
    @verification = Verification.new(verification_request: @verification_request)
    @verification.building = @verification_request.building
    @verification.user = @verification_request.user
    @verification.verifier = current_user
    if @verification.save
      redirect_to verification_requests_url, notice: 'Verification was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /verifications/1
  def update
    if  @verification.update(verification_params.merge(verifier_id: current_user.id))
      redirect_to verifications_url, notice: 'Verification was successfully updated.'
    else
      render :edit
    end
  end

  def revoke
    @verification.revoke!
    redirect_to :back
  end

  # DELETE /verifications/1
  def destroy
    @verification.destroy
    redirect_to verifications_url, notice: 'Verification was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_verification
    @verification = Verification.find(params[:id])
  end

  def set_verification_request
    @verification_request = VerificationRequest.find(params[:verification_request_id])
  end

  # Only allow a trusted parameter "white list" through.
  def verification_params
    params.require(:verification).permit(:verification_request_id)
  end
end
