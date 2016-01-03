def create_valid_alert
  @alert = create(:alert, user: @user,  building: @building, message: 'message')
end

def valid_alert_params
  { message: 'message' }
end
