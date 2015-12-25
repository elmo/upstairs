module BuildingsHelper
  def address(building)
    building.address
  end

  def building_short_address(building)
    building.address.split(',')[0..1].join(',')
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
    content_tag(:div, 'settings', id: 'setting', class: 'menu_item' ) do
      link_to(edit_user_registration_path) do
        content_tag(:div, 'o', id: 'icon_7', class: 'icon_menu') +
          content_tag(:div, I18n.t(:settings) ,id: 'setting_1', class: 'menu_item_text')
        end
      end
    end
  end

  def other_tenants_icon(user:, building:)
    content_tag(:div,'others', id: 'others', class: 'menu_item') do
      link_to(building_memberships_path(building)) do
          content_tag(:div, controller_name == 'memberships' ? 'J' : 'I', id: 'icon_4', class: 'icon_menu') +
        content_tag(:div, 'other tenants' ,id: 'other_tenants', class: 'menu_item_text')
      end
    end
  end

  def bulletin_board_icon(user:, building:)
      content_tag(:div, id: 'bulletin', class: 'menu_item') do
        link_to(building_posts_path(building)) do
          content_tag(:div, controller_name == 'posts' ? 'D' : 'C', id: 'icon', class: 'icon_menu') +
         content_tag(:div, I18n.t(:bulletin_board), id: 'bulletin_board', class: 'menu_item_text')
        end
      end
    end
  def alerts_icon(user:, building:)
    content_tag(:div, id: 'alert_1', class: 'menu_item') do
      content_tag(:div, controller_name == 'alerts' ? 'F' : 'E', id: 'icon', class: 'icon_menu') +
        link_to(building_alerts_path(building)) do
          content_tag(:div, I18n.t(:alerts) ,id: 'alert_2', class: 'menu_item_text') +
          (building.alerts_for_user(current_user).any? ? image_tag('news_element_icon.png', id: 'news_element_icon') : '')
      end
    end
  end

  def calendar_icon(user:, building:)
    content_tag(:div, 'calendar', id: 'calendar', class: 'menu_item') do
      link_to(building_events_path(building)) do
          content_tag(:div, controller_name == 'events' ? 'B' : 'A', id: 'icon_2', class: 'icon_menu') +
        content_tag(:div, I18n.t(:calendar), id: 'calendar_1', class: 'menu_item_text')
      end
    end
  end

  def messages_icon(user:, building:)
    content_tag(:div, 'message', id: 'message', class: 'menu_item') do
      link_to(inbox_path(building)) do
        content_tag(:div,controller_name == 'messages' ? 'H' : 'G', id: 'icon_3', class: 'icon_menu') +
        content_tag(:div, I18n.t(:message), id: 'message_1', class: 'menu_item_text') +
        ((current_user.has_unread_messages?) ? image_tag('news_element_icon.png', id: 'news_element_icon') : '')
      end
    end
  end

  def building_repairs_icon(user:, building:)
      content_tag(:div,'request',id: 'request', class: 'menu_item') do
      link_to new_building_ticket_path(building) do
        content_tag(:div, controller_name == 'tickets' ? 'L' : 'K', id: 'icon_5', class: 'icon_menu') +
        content_tag(:div, I18n.t(:tickets), id: 'request_a_repair', class: 'menu_item_text')
      end
    end
  end

  def invite_someone_icon(user:, building:)
      content_tag(:div,'invite',id: 'invite', class: 'menu_item') do
      link_to(new_building_user_invitation_path(building)) do
        content_tag(:div, controller_name == 'invitations' ? 'N' : 'M', id: 'icon_7', class: 'icon_menu') +
        content_tag(:div, I18n.t(:invite_someone), id: 'invite_someone', class: 'menu_item_text')
      end
    end
  end

  def building_public_profile_icon(building: building, user: user)
    content_tag(:div, 'profile', id: 'profil', class: 'menu_item' ) do
      link_to(building_user_path(building,user)) do
          content_tag(:div,  controller_name == 'users' ? 'R' : 'Q', id: 'icon_8', class: 'icon_menu') +
        content_tag(:div, I18n.t(:profile) , id: 'profil_1', class: 'menu_item_text')
      end
    end

 end

def upstairs_home_page_icon(id: nil, klass: nil)
    content_tag(:div, 'home', id: 'home' ) do
      link_to(root_url) do
        content_tag(:div, 'v', id: 'icon_9', class: 'home_icon_menu')
      end
    end

 end
def upstairs_home_page_icon_small(id: nil, klass: nil)
    content_tag(:div, 'home', id: 'home' ) do
      link_to(root_url) do
        content_tag(:div, 'u', id: 'icon_10', class: 'home_icon_menu_small')
      end
    end

 end
