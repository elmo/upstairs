class BuildingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building, only: [:show, :edit, :update, :gallery,:declare_ownership,:landlord_onboarding,:invite_your_landlord]
  before_action :set_template_directory, except: [:find, :choose, :index]
  before_action :ask_about_ownership, only: [:show]
  layout :get_layout

  def index
  end

  # GET /buildings/1
  def show
    @users = @building.users
    @posts = @building.posts.page(params[:page]).per(3).order('created_at desc')
    @events = @building.events.page(params[:page]).per(3).order('starts asc')
    @notifications = @building.notifications.order('created_at desc').limit(5)
    render template: "/buildings/#{@subdirectory}/show"
  end

  def choose
    @address = params[:address]
    @building = Building.where(address: params[:address]).first
    redirect_to building_path(@building) and return false if @building.present? && current_user.member_of?(@building)
    @building = Building.new(address: params[:address])
    @building.geocode
  end

  def declare_ownership
  end

  def landlord_onboarding
   current_user.profile_building_ownership_declared!
   current_user.make_landlord(@building)
  end

  def invite_your_landlord
   current_user.profile_building_ownership_declared!
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
    return %w(index choose).include?(action_name) ? 'users' : 'building'
  end

  def set_template_directory
    @subdirectory = @building.membership(current_user).membership_type.downcase.pluralize
  end

  def ask_about_ownership
    return unless current_user.present?
    return if current_user.profile_building_ownership_declared?
    redirect_to declare_ownership_building_path and return false
  end
end
