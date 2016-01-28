module Manage::UsersHelper

  def signature(user)
    link_to(user.username_or_email, manage_membership_path(user))
  end

end
