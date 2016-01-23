class UnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  # GET /units
  # GET /units.json
  def index
    @unit = @building.units.new
    scope = @building.units.includes(:tenancy)
    if params[:status]
      scope = scope.occupied if params[:status] == Unit::STATUS_OCCUPIED
      scope = scope.vacant if params[:status] == Unit::STATUS_VACANT
    end
    @units = scope.order('name').page(params[:page]).per(10)
  end

  # GET /units/1
  # GET /units/1.json
  def show
  end

  # GET /units/new
  def new
    @unit = @building.units.new
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  # POST /units.json
  def create
    @unit = @building.units.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to building_units_path(@building), notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to building_unit_path(@unit), notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to building_units_url(@building), notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_unit
    @unit = @building.units.find(params[:id])
  end

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def unit_params
    params.require(:unit).permit(:name)
  end
end
