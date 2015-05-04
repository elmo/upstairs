class AlertsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community
  before_action :set_alert, only: [:show, :edit, :update, :destroy]
  layout 'community'

  # GET /alerts
  def index
    @alerts = @community.alerts.order('created_at desc').page(params[:page]).per(10)
  end

  # GET /alerts/1
  def show
  end

  # GET /alerts/new
  def new
    @alert = @community.alerts.new(user: current_user)
  end

  # GET /alerts/1/edit
  def edit
    @alert = @community.alerts.friendly.find(params[:id])
  end

  # POST /alerts
  def create
    @alert = @community.alerts.new(alert_params)
    @alert.user = current_user

    if @alert.save
      redirect_to community_alert_path(@community, @alert), notice: 'Alert was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /alerts/1
  def update
    if @alert.update(alert_params)
      redirect_to community_alert_path(@community, @alert), notice: 'Alert was successfully created.'
    else
      render :edit
    end
  end

  # DELETE /alerts/1
  def destroy
    @alert.destroy
    redirect_to alerts_url, notice: 'Alert was successfully destroyed.'
  end

  private

    # Use callbacks to share common setup or constraints between actions.

    def set_community
      @community = Community.friendly.find(params[:community_id])
    end

    def set_alert
      @alert = Alert.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def alert_params
      params[:alert].permit(:message)
    end
end
