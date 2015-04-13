def load_user
  @user = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
end

