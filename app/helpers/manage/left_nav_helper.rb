module Manage::LeftNavHelper

   def manage_events_icon
     content_tag(:div, 'calendar', id: 'calendar', class: 'menu_item') do
       link_to manage_events_path do
         content_tag(:div, controller_name == 'events' ? 'B' : 'A', id: 'icon_2', class: 'icon_menu') +
         content_tag(:div, I18n.t(:calendar), id: 'calendar_1', class: 'menu_item_text')
       end
     end
   end

   def manage_posts_icon
     content_tag(:div, id: 'bulletin', class: 'menu_item') do
       link_to manage_posts_path do
         content_tag(:div, controller_name == 'posts' ? 'D' : 'C', id: 'icon', class: 'icon_menu') +
         content_tag(:div, I18n.t(:bulletin_board), id: 'bulletin_board', class: 'menu_item_text')
       end
     end
    end

    def manage_messages_icon
      content_tag(:div, 'message', id: 'message', class: 'menu_item') do
        link_to  manage_messages_path do
         content_tag(:div,controller_name == 'messages' ? 'H' : 'G', id: 'icon_3', class: 'icon_menu') +
         content_tag(:div, I18n.t(:message), id: 'message_1', class: 'menu_item_text') +
         ((current_user.received_messages.unread.any?) ? image_tag('news_element_icon.png', id: 'news_element_icon') : '')
      end
    end
    end

    def manage_tenants_icon
      content_tag(:div,'others', id: 'others', class: 'menu_item') do
        link_to manage_memberships_path do
          content_tag(:div, controller_name == 'memberships' ? 'J' : 'I', id: 'icon_4', class: 'icon_menu') +
          content_tag(:div, 'other tenants' ,id: 'other_tenants', class: 'menu_item_text')
        end
      end
   end

   def manage_alerts_icon
      content_tag(:div, id: 'alert_1', class: 'menu_item') do
        link_to manage_alerts_path do
          content_tag(:div, controller_name == 'alerts' ? 'F' : 'E', id: 'icon', class: 'icon_menu') +
          content_tag(:div, I18n.t(:alerts) ,id: 'alert_2', class: 'menu_item_text')
        end
    end
  end

    def manage_repairs_icon
       content_tag(:div,'request',id: 'request', class: 'menu_item') do
       link_to manage_tickets_path do
         content_tag(:div, controller_name == 'tickets' ? 'L' : 'K', id: 'icon_5', class: 'icon_menu') +
         content_tag(:div, I18n.t(:tickets), id: 'request_a_repair', class: 'menu_item_text'  )
       end
    end

  end
end

def manage_upstairs_home_page_icon_small
  content_tag(:div, 'home', id: 'home' ) do
    link_to(manage_buildings_path) do
      content_tag(:div, 'u', id: 'icon_10', class: 'home_icon_menu_small')
    end
  end
end

def manage_upstairs_home_page_icon
  content_tag(:div, 'home', id: 'home' ) do
      link_to(manage_buildings_path) do
        content_tag(:div, 'v', id: 'icon_9', class: 'home_icon_menu')
      end
    end
end

def user_logout_icon(user:, building:)
  content_tag(:div, 'exit', id: 'exit', class: 'menu_item' ) do
    link_to(destroy_user_session_path, method: :delete ) do
      content_tag(:div, 'w', id: 'icon_7', class: 'icon_menu') +
      content_tag(:div, I18n.t(:log_out) ,id: 'exit_1', class: 'menu_item_text')
    end
  end

end
