def load_user
  @user = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
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
