class VerificationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_verification, only: [:show, :edit, :update, :destroy]

  # GET /verifications
  def index
    @verifications = Verification.all
  end

  # GET /verifications/1
  def show
  end

  # GET /verifications/new
  def new
    @verification = Verification.new
  end

  # GET /verifications/1/edit
  def edit
    render :edit
  end

  # POST /verifications
  def create
    @verification = Verification.new(verification_params.merge(verifier_id: current_user.id))
    if @verification.save
      redirect_to @verification, notice: 'Verification was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /verifications/1
  def update
    if  @verification.update(verification_params.merge(verifier_id: current_user.id))
      redirect_to @verification, notice: 'Verification was successfully updated.'
    else
     render :edit
    end
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

    # Only allow a trusted parameter "white list" through.
    def verification_params
      params.require(:verification).permit(:building_id, :user_id, :verifier_id )
    end
end
