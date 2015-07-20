require "rails_helper"

RSpec.describe MessagesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/buildings/1/messages").to route_to("messages#index", building_id: "1")
    end

    it "routes to #new" do
      expect(:get => "/buildings/1/messages/new").to route_to("messages#new", building_id: "1")
    end

    it "routes to #show" do
      expect(:get => "/buildings/1/messages/1").to route_to("messages#show",  building_id: "1",:id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/buildings/1/messages/1/edit").to route_to("messages#edit", building_id: "1", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/buildings/1/messages").to route_to("messages#create", building_id: "1")
    end

    it "routes to #update" do
      expect(:put => "/buildings/1/messages/1").to route_to("messages#update",  building_id: "1", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/buildings/1/messages/1").to route_to("messages#destroy",  building_id: "1", :id => "1")
    end

  end
end
