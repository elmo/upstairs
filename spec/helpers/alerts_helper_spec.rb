require 'rails_helper'
RSpec.describe AlertsHelper, type: :helper do

    before(:each) do
      load_user
      load_unverified_builiding
    end

  it "recent_alerts renders if there are alerts" do
    @alert = create(:alert, building: @building, user: @user)
    expect(helper).to receive(:render).with(partial: '/alerts/recent').exactly(1).times
    helper.recent_alerts
  end

  it "recent_alerts renders if there are no alerts" do
    expect(helper).to receive(:render).with(partial: '/alerts/recent').exactly(0).times
    helper.recent_alerts
  end

end
