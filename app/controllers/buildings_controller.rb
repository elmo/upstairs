class BuildingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building, only: [:show, :edit, :update, :gallery, :declare_ownership, :landlord_onboarding, :invite_your_landlord, :residents, :building, :managers, :guests]
  before_action :set_template_directory, except: [:find, :choose, :index, :new]
  # before_action :ask_about_ownership, only: [:show]
  layout :get_layout

  def index
  end

  # GET /buildings/1
  def show
    render template: "/buildings/#{@subdirectory}/show"
  end

  def residents
    render template: "/buildings/#{@subdirectory}/residents"
  end

  def building
    render template: "/buildings/#{@subdirectory}/building"
  end

  def managers
    render template: "/buildings/#{@subdirectory}/managers"
  end

  def guests
    render template: "/buildings/#{@subdirectory}/guests"
  end

  def vendors
    render template: "/buildings/#{@subdirectory}/vendors"
  end

  def choose
    @address = params[:address]
    @building = Building.where(address: params[:address]).first
    redirect_to building_path(@building) and return false if @building.present? && current_user.member_of?(@building)
    @building = Building.new(address: params[:address])
    @building.geocode
    @building.save
    current_user.join(@building)
  end

  def declare_ownership
  end

  def landlord_onboarding
    current_user.profile_building_ownership_declared!
    current_user.make_landlord(@building)
    render template: "/buildings/#{@subdirectory}/invite_your_landlord"
  end

  def invite_your_landlord
    current_user.profile_building_ownership_declared!
    render template: "/buildings/#{@subdirectory}/invite_your_landlord"
  end

  # GET /buildings/new
  def new
    @building = Building.where(address: params[:address]).first
    if @building.present?
      current_user.join(@building)
      current_user.profile_building_chosen!
      redirect_to building_path(@building)
    end
    @building = Building.new(address: params[:address])
    @building.geocode
    @building.save
  end

  # GET /buildings/1/edit
  def edit
  end

  def update
    if @building.update(building_params)
      redirect_to edit_building_path(@building), notice: 'Building was successfully updated.'
    else
      render :edit
    end
  end

  # POST /buildings
  def create
    @building = Building.where(address: building_params[:address]).first
    if @building.present?
      current_user.join(@building)
      redirect_to @building, notice: "Welcome, to #{@building.address}. You are now a member." and return false
    end
    @building = Building.new(building_params)
    if @building.save
      current_user.join(@building)
      redirect_to @building, notice: "Welcome, to #{@building.address}. You are now a member." and return false
    else
      render :new
    end
  end

  def gallery
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_building
    @building = Building.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def building_params
    params.require(:building).permit(:name, :address, photos: [])
  end

  def get_layout
    %w(index choose).include?(action_name) ? 'users' : 'building'
  end

  def set_template_directory
    @subdirectory = 'guests'
    @subdirectory = 'landlords' if current_user.landlord_of?(@building)
    @subdirectory = 'managers' if current_user.manager_of?(@building)
    @subdirectory = 'tenants' if current_user.tenant_of?(@building)
  end

  def ask_about_ownership
    return unless current_user.present?
    return if current_user.profile_building_ownership_declared?
    redirect_to declare_ownership_building_path and return false
  end
end
