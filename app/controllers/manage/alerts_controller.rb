class Manage::AlertsController < Manage::ManageController
  before_action :set_alert, only: [:show, :edit, :update, :destroy]
  layout 'building'

  # GET /alerts
  def index
    scope = Alert.managed_by(current_user)
    scope = scope.where(['message like ? ', "%#{params[:searchTextField]}%"]) if params[:searchTextField]
    @alerts = scope.order('created_at desc').page(params[:page]).per(10)
  end

  # GET /alerts/1
  def show
  end

  # GET /alerts/new
  def new
    @alert = @building.alerts.new(user: current_user)
  end

  # GET /alerts/1/edit
  def edit
    @alert = @building.alerts.find(params[:id])
  end

  # POST /alerts
  def create
    @alert = @building.alerts.new(alert_params)
    @alert.user = current_user

    if @alert.save
      redirect_to building_alerts_path(@building), notice: 'Alert was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /alerts/1
  def update
    if @alert.update(alert_params)
      redirect_to building_alerts_path(@building), notice: 'Alert was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /alerts/1
  def destroy
    @alert.destroy
    redirect_to building_alerts_url(@building), notice: 'Alert was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end

  def set_alert
    @alert = Alert.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def alert_params
    params[:alert].permit(:message)
  end
end
