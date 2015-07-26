def create_valid_ticket
  @ticket = create(:ticket, building: @building, user: @user, title: "title", body: "body", severity: 'low', status: 'new')
end
