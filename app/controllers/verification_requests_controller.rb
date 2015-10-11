class VerificationRequestsController < ApplicationController
  before_action :authenticate_user!
  layout :get_layout
  before_action :set_building, except: [:index, :show, :edit, :update,:destroy]
  authorize_resource VerificationRequest, except: [:new, :create, :index, :show, :edit, :update, :destroy]
  check_authorization except: [:new, :create, :index,:show, :edit, :update, :destroy]
  #before_action :set_verification_request, only: [:edit, :destroy]

  # GET /verification_requests
  def index
    @verification_requests = VerificationRequest.page(params[:page]).per(10)
  end

  # GET /verification_requests/1
  def show
    @verification_request = VerificationRequest.find(params[:id])
  end

  # GET /verification_requests/new
  def new
    @verification_request = @building.verification_requests.new
  end

  # GET /verification_requests/1/edit
  def edit
    @verification_request = VerificationRequest.find(params[:id])
  end

  # POST /verification_requests
  def create
    @verification_request = @building.verification_requests.new(verification_request_params.merge(user_id: current_user.id))
    if @verification_request.save
      redirect_to building_path(@building), notice: 'Verification request was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /verification_requests/1
  def update
    @verification_request = VerificationRequest.find(params[:id])
    if @verification_request.update(verification_request_params.merge(user_id: current_user.id))
      redirect_to verification_requests_url, notice: 'Verification request was successfully updated.'
    else
      render :edit
    end
  end

  def reject
    @verification_request = VerificationRequest.find(params[:id])
    @verification.rejected!
    redirect_to :back
  end

  # DELETE /verification_requests/1
  def destroy
    @verification_request = VerificationRequest.find(params[:id])
    @verification_request.destroy
    redirect_to verification_requests_url, notice: 'Verification request was successfully destroyed.'
  end

  private

    def set_building
      @building = Building.friendly.find(params[:building_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_verification_request
      @verification_request = @building.verification_requests.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def verification_request_params
      params.require(:verification_request).permit(:user_id, :building_id, :status)
    end

    def get_layout
      action_name == "new" ? 'building' : 'application'
    end

end
