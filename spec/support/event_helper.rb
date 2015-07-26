def create_valid_event
  @event = create(:event, building: @building, user: @user, starts: Date.today + 2.days)
end
