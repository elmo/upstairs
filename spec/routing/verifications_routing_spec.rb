require "rails_helper"

RSpec.describe VerificationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/verifications").to route_to("verifications#index")
    end

    it "routes to #new" do
      expect(:get => "/verifications/new").to route_to("verifications#new")
    end

    it "routes to #show" do
      expect(:get => "/verifications/1").to route_to("verifications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/verifications/1/edit").to route_to("verifications#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/verifications").to route_to("verifications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/verifications/1").to route_to("verifications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/verifications/1").to route_to("verifications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/verifications/1").to route_to("verifications#destroy", :id => "1")
    end

  end
end
