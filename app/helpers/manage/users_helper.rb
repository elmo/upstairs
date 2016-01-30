module Manage::UsersHelper

  def signature(user)
    link_to(user.username_or_email, manage_membership_path(user))
  end

  def building_membership_relationship(membership)
    "#{membership.membership_type.downcase} of #{membership.building.short_name}"
  end

  def remove_building_relationship_link(membership)
     link_to("remove",
	     manage_membership_path(membership.to_param, building_id: membership.building.to_param),
	     data: { confirm: "Are you sure that you would like to remove #{membership.user.email} " +
		              " as a #{membership.membership_type.downcase} from #{membership.building.address}?" },
	             method: :delete )
  end

  def new_message_link(membership)
    link_to("send message", new_manage_building_message_path(membership.building, user_id: membership.user.to_param) )
  end

end
