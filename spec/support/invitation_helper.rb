def create_valid_invitation
  @invitation = create(:user_invitation, building: @building, user: @user, email: 'invitee@email.com')
end
