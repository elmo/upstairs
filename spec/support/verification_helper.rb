def build_verification
  @verification = build(:verification, user: @user, building: @building, verification_request: @verification_request, verifier: @verifier)
end
