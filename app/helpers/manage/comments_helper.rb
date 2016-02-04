module Manage::CommentsHelper

  def manage_delete_link(commentable:, comment:)
    if current_user.owns?(comment)
      link_to 'delete',  polymorphic_url([:manage, commentable, comment]), method: :delete
    end
  end
end
