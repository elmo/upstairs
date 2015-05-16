module ApplicationHelper

  def footer
    (['home'].include?(controller_name)  and action_name == 'index') ? big_footer : narrow_footer
  end

  def big_footer
    render partial: '/layouts/big_footer'
  end

  def narrow_footer
    render partial: '/layouts/narrow_footer'
  end

  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end

  def upstairs_time_format
    "%B %d, %Y %I:%S %p"
  end

  def by_line(obj)
   link_to(username_or_anonymous(obj.user), community_user_path(obj.community, obj.user)) + ' at '+  obj.created_at.strftime(upstairs_time_format)
  end

  def username_or_anonymous(user)
   (usable_username?(user))  ? user.username : 'Anonymous'
  end

  def usable_username?(user)
    user.use_my_username? and user.username.present?
  end

  def user_mini_summary(user)
    username_or_anonymous(user) + ' joined ' +  user.created_at.strftime(upstairs_time_format)
  end

  def notification_summary(notification)
    link_to(username_or_anonymous(notification.user) , community_user_path(notification.community, notification.user) ) +
    notification.notifiable.verb  +
    notification.notifiable.class.to_s.downcase +  ' ' +
    link_to(notification.notifiable.name, [notification.notifiable.grandparent.postable, notification.notifiable.grandparent]) + ' on ' +
    notification.notifiable.created_at.strftime(upstairs_time_format)
  end

  def activity_summary(activity)
    actionable = activity.actionable
    case activity.actionable.class.to_s
      when "Alert"
        alert_summary(actionable)
      when "Comment"
        comment_summary(actionable)
      when "Post"
        post_summary(actionable)
      when "Ticket"
        ticket_summary(actionable)
      when "Classified"
        ticket_summary(actionable)
      else
        raise "Unknown activity type"
      end.html_safe
  end

  def alert_summary(alert)
   alert.created_at.strftime(upstairs_time_format) + " " +
   link_to(username_or_anonymous(alert.user), community_user_path(alert.community, alert.user)) + " created " + link_to('alert', community_alert_path(alert.community, alert)) +
   " " + alert.message
  end

  def comment_summary(comment)
    if comment.reply?
      comment.created_at.strftime(upstairs_time_format) + " " +
      link_to(username_or_anonymous(comment.user), community_user_path(comment.comment.commentable.postable, comment.user)) + " replied to " +
      link_to(username_or_anonymous(comment.comment.user) , user_path(comment.comment.user) ) + "'s comment on " +
      link_to(username_or_anonymous(comment.comment.commentable.user), user_path(comment.comment.commentable.user) ) + "'s post: "  +
      link_to(comment.comment.commentable.title, community_post_path( comment.comment.commentable.postable, comment.comment.commentable))
    elsif comment.commentable.class.to_s == 'Ticket'
      comment.created_at.strftime(upstairs_time_format) + " commented on " +
      link_to(username_or_anonymous(comment.user), community_user_path(comment.commentable.community, comment.commentable.user)  ) + "'s ticket: " +
      link_to(comment.commentable.title, community_ticket_path(comment.commentable.community, comment.commentable))
    else
      comment.created_at.strftime(upstairs_time_format) + " commented on " +
      link_to(username_or_anonymous(comment.commentable.user), community_user_path(comment.commentable.postable, comment.commentable.user)  ) + "'s post:"  +
      link_to(comment.commentable.title, community_post_path(comment.commentable.postable, comment.commentable))
    end
  end

  def post_summary(post)
   post.created_at.strftime(upstairs_time_format) + " " +
   link_to(username_or_anonymous(post.user), community_user_path(post.postable, post.user)) +
   " posted " +
   link_to( post.title, community_post_path(post.postable, post))
  end

  def ticket_summary(ticket)
   ticket.created_at.strftime(upstairs_time_format) + " " +
   link_to(username_or_anonymous(ticket.user), community_user_path(ticket.community, ticket.user)) +
   " opened ticket " +
   link_to( ticket.title, community_ticket_path(ticket.community, ticket))
  end

  def classified_summary(classified)
   classified.created_at.strftime(upstairs_time_format) + " " +
   link_to(username_or_anonymous(classified.user), community_user_path(classified.community, classified.user)) +
   " created classified " +
   link_to(classified.title, community_classified_path(classified.community, classified))
  end

end
