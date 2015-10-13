def load_valid_verification_request
  @verification_request = create(:verification_request, user: @user, building: @building, status: VerificationRequest::STATUS_PENDING)
end
