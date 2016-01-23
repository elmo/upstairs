def load_user
  @user = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
end

def load_another_user
  @user2 = create(:user, email: "#{SecureRandom.hex(6)}-another@email.com")
end

def load_verifier
  @verifier = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
end

def load_sender
  @sender = create(:user, email: "#{SecureRandom.hex(6)}-sender@email.com")
end

def load_recipient
  @recipient = create(:user, email: "#{SecureRandom.hex(6)}-recipient@email.com")
end

def load_landlord(building)
  @landlord = create(:user, email: "#{SecureRandom.hex(6)}-landlord@email.com")
  @landlord.make_landlord(building)
end

def load_admin
  @admin = create(:user, email: "#{SecureRandom.hex(6)}-admin@email.com")
  @admin.make_admin
end
