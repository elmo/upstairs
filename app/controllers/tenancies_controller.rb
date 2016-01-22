class TenanciesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_unit_and_building
  before_action :set_tenancy, only: [:show, :edit, :update, :destroy]

  # GET /tenancies
  # GET /tenancies.json
  def index
    @tenancy = @building.tenancies.page(params[:page]).per(10)
  end

  # GET /tenancies/1
  # GET /tenancies/1.json
  def show
  end

  # GET /tenancies/new
  def new
    @tenancy = @building.tenancies.new
  end

  # GET /tenancies/1/edit
  def edit
  end

  # POST /tenancies
  # POST /tenancies.json
  def create
    @user = User.find(tenancy_params[:user_id])
    respond_to do |format|
      if @unit.create_tenancy_for(user: @user)
        format.html { redirect_to building_units_path(@building), notice: 'Tenancy was successfully saved.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /tenancies/1
  # PATCH/PUT /tenancies/1.json
  def update
    respond_to do |format|
      if @tenancy.update(tenancy_params)
        format.html { redirect_to builing_tenancy_path(@building, @tenancy), notice: 'Tenancy was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /tenancies/1
  # DELETE /tenancies/1.json
  def destroy
    @tenancy.destroy
    respond_to do |format|
      format.html { redirect_to building_units_path(@building), notice: 'Tenancy was successfully created.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tenancy
    @tenancy = @building.tenancies.find(params[:id])
  end

  def set_unit_and_building
    @unit = Unit.find(params[:unit_id])
    @building = @unit.building
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tenancy_params
    params[:tenancy].permit(:user_id)
  end
end
