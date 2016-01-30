module Manage::BuildingHelper

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

  def manange_building_link(building)
    link_to building.short_name, manage_building_path(building)
  end

  def view_post_link(post)
    link_to 'view', building_post_path(post.building, post.to_param)
  end

  def manage_post_link(post)
    link_to 'manage', manage_post_path(post.to_param)
  end

  def view_event_link(event)
    link_to 'view', building_event_path(post.building, post.to_param)
  end

  def created_at(obj)
    time_ago_in_words(obj.created_at)
  end

end
