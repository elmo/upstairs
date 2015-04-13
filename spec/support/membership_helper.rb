def load_user_and_community
  @user = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
  @community = create(:community)
end

def load_membership
  load_user_and_community
  @user.join(@community)
end
