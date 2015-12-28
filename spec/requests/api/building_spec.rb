require "rails_helper"

RSpec.describe "Building", :type => :request do
  before(:each) do
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    load_building
  end

  it "reads building information" do
    get "/api/buildings/#{@building.id}.json", {}, @env
    expect(response.body).to be_json_eql({building: @building}.to_json)
  end

end
