def load_user_and_building
  @user = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
  @building = create(:building)
end

def load_membership
  load_user_and_building
  @user.join(@building)
end
