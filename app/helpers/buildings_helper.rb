module BuildingsHelper
  def address(building, _delimitter = '<br>')
    building.address
  end

  def current_user_left_nav(building:, user:)
    render partial: '/buildings/left_nav'
  end

  def current_user_view(building:, user:)
    if building.owner_verified?
      render partial: '/buildings/member_of_verified_building_view'
    else
      render partial: '/buildings/member_of_unverified_building_view'
    end
  end

  def alert_bar(building:, user:)
    render partial: '/buildings/alerts'
  end

  def upstairs_home_page_icon(id: nil, klass: nil)
    content_tag :div, id: id, class: klass do
      link_to(image_tag('upstairs_home_page_icon.png'), root_url)
    end
  end

  def building_home_icon(building: building, id: nil, klass: nil)
    content_tag :div, id: id, class: klass do
      link_to 'home', building_path(building)
    end
  end

  def building_bulletin_board_icon(building: building, id: nil, klass: nil)
    content_tag :div, id: id, class: klass do
      link_to 'bulletin', building_posts_path(building)
    end if (controller_name != 'posts')
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

  def building_invite_icon(building: building, id: nil, klass: nil)
    content_tag :div, id: id, class: klass do
      link_to 'invite', new_building_invitation_path(building)
    end if (controller_name != 'invitations')
  end


  def user_settings_icon(user:, building:)
    content_tag(:div, 'setting', id: 'setting' ) do
      link_to(edit_user_registration_path) do
        content_tag(:div, 'o', id: 'icon_7', class: 'icon_menu') +
        content_tag(:div, 'setting' ,id: 'setting_1')
        end
      end
    end
  end

  def other_tenants_icon(user:, building:)
    content_tag(:div,'others', id: 'others') do
      link_to(building_memberships_path(building)) do
        content_tag(:div, 'i', id: 'icon_4', class: 'icon_menu') +
        content_tag(:div, 'other tenants' ,id: 'other_tenants')
      end
    end
  end

  def bulletin_board_icon(user:, building:)
    content_tag(:div, id: 'bulletin') do
      link_to(building_posts_path(building)) do
        content_tag(:div, 'D', id: 'icon', class: 'icon_menu') +
        content_tag(:div, 'Bulletin Board' ,id: 'bulletin_board')
      end
    end
  end

  def alerts_icon(user:, building:)
    content_tag(:div, id: 'alert_1') do
      content_tag(:div, 'e', id: 'icon', class: 'icon_menu') +
      link_to(building_alerts_path(building)) do
        content_tag(:div, 'alerts' ,id: 'alert_2') +
          image_tag('news_element_icon.png', id: 'news_element_icon')
      end
    end
  end

  def calendar_icon(user:, building:)
    content_tag(:div, 'calendar', id: 'calendar') do
      link_to(building_events_path(building)) do
        content_tag(:div, 'a', id: 'icon_2', class: 'icon_menu') +
        content_tag(:div, 'calendar' ,id: 'calendar_1')
      end
    end
  end

  def messages_icon(user:, building:)
    content_tag(:div, 'message', id: 'message') do
      link_to(inbox_path(building)) do
        content_tag(:div, 'g', id: 'icon_3', class: 'icon_menu') +
        content_tag(:div, 'message' ,id: 'message_1')
      end
    end
  end

  def building_repairs_icon(user:, building:)
    content_tag(:div,'request') do
      link_to new_building_ticket_path(building) do
        content_tag(:div, 'k', id: 'icon_5', class: 'icon_menu') +
        content_tag(:div, 'request a repair' ,id: 'request_a_repair')
      end
    end + content_tag(:br)
  end

  def invite_someone_icon(user:, building:)
    content_tag(:div,'invite') do
      link_to(new_building_user_invitation_path(building)) do
        content_tag(:div, 'm', id: 'icon_7', class: 'icon_menu') +
        content_tag(:div, 'invite someone' ,id: 'invite_someone')
      end
    end
  end

  def building_public_profile_icon(building: building, user: user)
    content_tag(:div, 'profile', id: 'profil' ) do
      link_to(building_user_path(building,user)) do
        content_tag(:div, 'q', id: 'icon_8', class: 'icon_menu') +
        content_tag(:div, 'profile' ,id: 'profil_1')
      end
    end

 end
