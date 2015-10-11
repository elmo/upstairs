def load_valid_verfication_request
  @verification_request = create(:verification_request, user: @user, building: @building, status: VerificationRequest::STATUS_PENDING)
end
