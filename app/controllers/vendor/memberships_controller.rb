class Vendor::MembershipsController < Vendor::VendorController

  def show
    @assignments = Assignment.assigned_to_user(current_user).page(1).per(5)
  end

end
