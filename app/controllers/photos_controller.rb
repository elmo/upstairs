class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  layout 'building'

  # GET /photos
  def index
    @photos = @building.photos.page(params[:page]).per(1)
  end

  # GET /photos/1
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      redirect_to @photo, notice: 'Photo was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /photos/1
  def update
    if @photo.update(photo_params)
      redirect_to @photo, notice: 'Photo was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /photos/1
  def destroy
    @photo.destroy
    redirect_to photos_url, notice: 'Photo was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_photo
    @photo = Photo.find(params[:id])
  end

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end

  # Only allow a trusted parameter "white list" through.
  def photo_params
    params[:photo]
  end
end
