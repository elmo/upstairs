module UsersHelper
  def landlord_link(user:, building:)
    user.landlord_of?(building) ? 'landlord' : ''
  end

  def user_profile_image(_building, user, size = 'smallest', crop = 'fit', classP = 'photoP', id = 'photo')
    dimensions_method = size + '_image_dimensions'
    dimensions = send(dimensions_method.to_sym)
    image = (usable_username?(user) && user.avatar.present?) ?
      cl_image_tag(user.avatar.path, size: dimensions, crop: crop, id: id, class: classP) :
      anonymous_user_icon(dimensions)
    image
end

  def show_user_bg(user, size = 'smallest', crop = 'fit')
    dimensions_method = size + '_image_dimensions'
    dimensions = send(dimensions_method.to_sym)
    image = (usable_username?(user) && user.avatar.present?) ?
      "background-image:url(#{cl_image_path(user.avatar.path, size: dimensions, crop: crop)});" :
      "background-image:url(#{anonymous_user_icon(dimensions)});"

    image
  end

  def anonymous_user_icon(dimensions)
    height, width = dimensions.split('x')
    cl_image_tag('anonymous.png', width: width, height: height, crop: :fit, id: 'photo')
  end

  def username_or_email(user)
    (user.username.present?) ? user.username : user.email
  end

  def membership_landing_link(membership)
    case membership.membership_type
      when Membership::MEMBERSHIP_TYPE_GUEST, Membership::MEMBERSHIP_TYPE_TENANT
        link_to "visit", membership_landing_url(membership)
      when Membership::MEMBERSHIP_TYPE_VENDOR
        link_to "manage business relationship", membership_landing_url(membership)
      when Membership::MEMBERSHIP_TYPE_MANAGER, Membership::MEMBERSHIP_TYPE_LANDLORD
        link_to "manage", membership_landing_url(membership)
    end
  end

  def membership_landing_url(membership)
    case membership.membership_type
      when Membership::MEMBERSHIP_TYPE_GUEST, Membership::MEMBERSHIP_TYPE_TENANT
        building_path(membership.building)
      when Membership::MEMBERSHIP_TYPE_VENDOR
        vendor_membership_path
      when Membership::MEMBERSHIP_TYPE_MANAGER, Membership::MEMBERSHIP_TYPE_LANDLORD
        manage_buildings_path
     end
  end


end
