module BuildingsHelper

 def address(building,delimitter = "<br>")
    building.address
 end

 def current_user_left_nav(building:, user:)
   if building.owner_verified?
     render partial: '/buildings/owner_verified_left_nav'
   else
     render partial: '/buildings/owner_not_verified_left_nav'
   end
 end

 def current_user_view(building:, user:)
   if building.owner_verified?
     if user.verified_owner_of?(building)
       render partial: '/buildings/verified_owner_view'
     else
       render partial: '/buildings/member_of_verified_building_view'
     end
   else
     render partial: '/buildings/member_of_unverified_building_view'
   end
 end

 def alert_bar(building:, user:)
   render partial: '/buildings/alerts'
 end

 def upstairs_home_page_icon(id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'upstairs', root_url
   end
 end

 def building_home_icon(building: building, id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'home', building_path(building)
   end if (controller_name != 'buildings' and action_name != 'home')
 end

 def building_bulletin_board_icon(building: building, id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'bulletin', building_posts_path(building)
   end if (controller_name != 'posts')
 end

 def building_alerts_icon(building: building, id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'alerts', building_posts_path(building)
   end if (controller_name != 'alerts')
 end

 def building_calendar_icon(building: building, id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'calendar', building_events_path(building)
   end if (controller_name != 'events')
 end

 def building_messages_icon(building: building, id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'messages', inbox_path(building)
   end if (controller_name != 'messages')
 end

 def building_members_icon(building: building, id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'members', building_memberships_path(building)
   end if (controller_name != 'memberships')
 end

 def building_repairs_icon(building: building, id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'repairs', building_tickets_path(building)
   end if (controller_name != 'tickets')
 end

 def building_invite_icon(building: building, id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'invite', new_building_invitation_path(building)
   end if (controller_name != 'invitations')
 end


 def building_public_profile_icon(building: building, user: user,  id: nil, klass: nil)
   content_tag :div, id: id, class: klass do
     link_to 'public profile', building_user_path(building, user)
   end if (controller_name != 'users')
 end

 end
