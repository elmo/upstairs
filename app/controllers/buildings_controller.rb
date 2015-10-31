class BuildingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building, only: [:show, :edit, :update, :gallery]
  layout :get_layout

  def index
  end

  # GET /buildings/1
  def show
    @users = @building.users
    @posts = @building.posts.page(params[:page]).per(10).order('created_at desc')
    @notifications = @building.notifications.order('created_at desc').limit(5)
  end

  def choose
    @address = params[:address]
    @building = Building.where(address: params[:address]).first
    redirect_to building_path(@building) and return false if @building.present? && current_user.member_of?(@building)
    @building = Building.new(address: params[:address])
    @building.geocode
  end

  # GET /buildings/new
  def new
    @building = Building.where(address: params[:address]).first
    if @building.present?
      current_user.join(@building)
      redirect_to building_path(@building)
    end
    @building = Building.new(address: params[:address])
    @building.geocode
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
    return %w(index choose).include?(action_name) ? 'users' : 'building'
  end
end
