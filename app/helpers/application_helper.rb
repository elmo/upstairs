module ApplicationHelper
  def footer
    (['home'].include?(controller_name) && action_name == 'index') ? big_footer : narrow_footer
  end

  def big_footer
    render partial: '/layouts/big_footer'
  end

  def narrow_footer
    render partial: '/layouts/narrow_footer'
  end

  def us_states
    [
      %w(Alabama AL),
      %w(Alaska AK),
      %w(Arizona AZ),
      %w(Arkansas AR),
      %w(California CA),
      %w(Colorado CO),
      %w(Connecticut CT),
      %w(Delaware DE),
      ['District of Columbia', 'DC'],
      %w(Florida FL),
      %w(Georgia GA),
      %w(Hawaii HI),
      %w(Idaho ID),
      %w(Illinois IL),
      %w(Indiana IN),
      %w(Iowa IA),
      %w(Kansas KS),
      %w(Kentucky KY),
      %w(Louisiana LA),
      %w(Maine ME),
      %w(Maryland MD),
      %w(Massachusetts MA),
      %w(Michigan MI),
      %w(Minnesota MN),
      %w(Mississippi MS),
      %w(Missouri MO),
      %w(Montana MT),
      %w(Nebraska NE),
      %w(Nevada NV),
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      %w(Ohio OH),
      %w(Oklahoma OK),
      %w(Oregon OR),
      %w(Pennsylvania PA),
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      %w(Tennessee TN),
      %w(Texas TX),
      %w(Utah UT),
      %w(Vermont VT),
      %w(Virginia VA),
      %w(Washington WA),
      ['West Virginia', 'WV'],
      %w(Wisconsin WI),
      %w(Wyoming WY)
    ]
  end

  def upstairs_time_format
    '%m/%d %I:%S %p'
  end

  def by_line(obj, with_icon: false)
    content_tag(:span, class: 'byline') do
      ((with_icon && obj.user.avatar.present?) ? cl_image_tag(obj.user.avatar.path, size: '40x40', crop: :fit) : '') +
      link_to(username_or_anonymous(obj.user), building_user_path(obj.building, obj.user.slug)) +
        ' at ' + obj.created_at.strftime(upstairs_time_format)

    end
  end

  def username_or_anonymous(user)
    (usable_username?(user)) ? user.username : 'Anonymous'
  end

  def usable_username?(user)
    user.use_my_username? && user.username.present?
  end

  def user_mini_summary(_building, user)
    link_to(((user.avatar.present?) ? cl_image_tag(user.avatar.path, size: '60x80', crop: :fit) : '') + username_or_anonymous(user), building_user_path(user)) +
      + ' joined ' + user.created_at.strftime(upstairs_time_format)
  end

  def notification_summary(notification)
    link_to(username_or_anonymous(notification.user), building_user_path(notification.building, notification.user)) +
      notification.notifiable.verb + notification.notifiable.class.to_s.downcase + ' ' +
      link_to(notification.notifiable.name, [notification.notifiable.grandparent.postable, notification.notifiable.grandparent]) + ' on ' +
      notification.notifiable.created_at.strftime(upstairs_time_format)
  end

  def activity_summary(activity)
    actionable = activity.actionable
    content_tag(:span, class: 'activity') do
      case activity.actionable.class.to_s
        when 'Alert'
          alert_summary(actionable)
        when 'Comment'
          comment_summary(actionable)
        when 'Post'
          post_summary(actionable)
        when 'Ticket'
          ticket_summary(actionable)
        when 'Classified'
          ticket_summary(actionable)
        else
          fail 'Unknown activity type'
        end.html_safe
    end
  end

  def alert_summary(alert)
    alert.created_at.strftime(upstairs_time_format) + ' ' +
      link_to(username_or_anonymous(alert.user), building_user_path(alert.building, alert.user.slug)) + ' created ' + link_to('alert', building_alert_path(alert.building, alert))
  end

  def comment_summary(comment)
    if comment.reply?
      comment.created_at.strftime(upstairs_time_format) + ' ' +
        link_to(username_or_anonymous(comment.user), building_user_path(comment.comment.commentable.postable, comment.user.slug)) + ' replied to ' +
        link_to(username_or_anonymous(comment.comment.user), building_user_path(comment.comment.commentable.postable, comment.comment.user.slug)) + "'s comment on " +
        link_to(username_or_anonymous(comment.comment.commentable.user), building_user_path(comment.comment.commentable.postable, comment.comment.commentable.user.slug)) + "'s " + link_to('note', building_post_path(comment.comment.commentable.postable, comment.comment.commentable))
    elsif comment.commentable.class.to_s == 'Ticket'
      comment.created_at.strftime(upstairs_time_format) + ' commented on ' +
        link_to(username_or_anonymous(comment.user), building_user_path(comment.commentable.building, comment.commentable.user.slug)) + "'s " +
        link_to('ticket', building_ticket_path(comment.commentable.building, comment.commentable))
    else
      comment.created_at.strftime(upstairs_time_format) + ' ' +
        link_to(username_or_anonymous(comment.user), building_user_path(comment.building, comment.user.slug)) + ' commented on ' + link_to(username_or_anonymous(comment.commentable.user), building_user_path(comment.commentable.postable, comment.commentable.user.slug)) + "'s " + link_to('post', building_post_path(comment.commentable.postable, comment.commentable))
    end
  end

  def post_summary(post)
    post.created_at.strftime(upstairs_time_format) + ' ' +
      link_to(username_or_anonymous(post.user), building_user_path(post.postable, post.user.slug)) +
      ' posted a ' +
      link_to('note', building_post_path(post.postable, post))
  end

  def ticket_summary(ticket)
    ticket.created_at.strftime(upstairs_time_format) + ' ' +
      link_to(username_or_anonymous(ticket.user), building_user_path(ticket.building, ticket.user.slug)) +
      ' opened ' +
      link_to('repair request', building_ticket_path(ticket.building, ticket))
  end

  def ticket_status_badge(ticket)
    content_tag(:span, ticket.status, class: "badge badge-status-#{ticket.status.downcase}")
  end

  def ticket_severity_badge(ticket)
    content_tag(:span,  ticket.severity, class: "badge badge-severity-#{ticket.severity.downcase}")
  end

  def smallest_image_dimensions
    '40x40'
  end

  def small_image_dimensions
    '60x60'
  end

  def medium_image_dimensions
    '120x120'
  end

  def large_image_dimensions
    '200x200'
  end

  def huge_image_dimensions
    '400x400'
  end

  def current_section
    case controller_name
      when 'posts'
        'bulletin board'
      when  'alerts'
        'alerts'
      when 'events'
        'calendar'
      when 'messages'
        'messages'
      when 'memberships'
        'members'
      when 'tickets'
        'tickets'
      when 'invitations'
        'invitations'
      when 'buildings'
        'buildings'
      when 'users'
        'users'
      else
        ''
    end
  end

  def current_title
    case controller_name
      when 'posts'
        'bulletin board'
      when  'alerts'
        'alerts'
      when 'events'
        'calendar'
      when 'messages'
        'messages'
      when 'memberships'
        'members'
      when 'tickets'
        'tickets'
      when 'invitations'
        'invitations'
      when 'buildings'
        'buildings'
      when 'users'
        'users'
      else
        ''
    end
  end

  def search_and_filter_nav
   case current_section
   when 'bulletin board'
     render partial: '/posts/search_and_filter_nav'
   when 'alerts'
     render partial: '/alerts/search_and_filter_nav'
   when  'calendar'
     render partial: '/events/search_and_filter_nav'
   when 'messages'
     render partial: '/messages/search_and_filter_nav'
    when 'members'
     render partial: '/memberships/search_and_filter_nav'
    when 'tickets'
     render partial: '/tickets/search_and_filter_nav'
    when 'invitations'
     render partial: '/invitations/search_and_filter_nav'
    when 'buildings'
     render partial: '/buildings/search_and_filter_nav'
    when 'users'
     render partial: '/users/search_and_filter_nav'
    end
  end

end
 def favicon_link_tag(source='fav_icon.ico', options={})
        tag('link', {
          :rel  => 'shortcut icon',
          :type => 'image/x-icon',
          :href => path_to_image(source)
        }.merge!(options.symbolize_keys))
      end
