def create_valid_event
  @event = create(:event, building: @building, user: @user, title: 'title', body: 'body', starts: Date.today + 2.days)
end

def valid_event_params
  { title: 'title', body: 'body', starts: (Date.today + 2.days).to_s }
end
