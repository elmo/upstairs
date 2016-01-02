require "rails_helper"

RSpec.describe "User", :type => :request do
  before(:each) do
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    load_user
  end

  it "reads user information" do
    get "/api/user/#{@user.id}.json", {}, @env
    expect(response.body).to be_json_eql({user: @user}.to_json)
  end

end
