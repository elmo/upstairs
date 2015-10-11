require "rails_helper"

RSpec.describe VerificationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/verifications").to route_to("verifications#index")
    end

    it "routes to #revoke" do
      expect(:put => "/verifications/1/revoke").to route_to("verifications#revoke", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/verifications/1").to route_to("verifications#destroy", :id => "1")
    end

  end
end
