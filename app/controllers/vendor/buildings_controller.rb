class Vendor::BuildingsController < Vendor::VendorController
  before_action :set_building, except: :index

  def index
    buildings = current_user.client_buildings
    @buildings = Kaminari.paginate_array(buildings).page(params[:page]).per(10)
  end

  def show
    @building = Building.friendly.find(params[:id])
  end

  private

  def set_building
    @building = Building.friendly.find(params[:id])
  end

end
