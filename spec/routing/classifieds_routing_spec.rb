require "rails_helper"

RSpec.describe ClassifiedsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/classifieds").to route_to("classifieds#index")
    end

    it "routes to #new" do
      expect(:get => "/classifieds/new").to route_to("classifieds#new")
    end

    it "routes to #show" do
      expect(:get => "/classifieds/1").to route_to("classifieds#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/classifieds/1/edit").to route_to("classifieds#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/classifieds").to route_to("classifieds#create")
    end

    it "routes to #update" do
      expect(:put => "/classifieds/1").to route_to("classifieds#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/classifieds/1").to route_to("classifieds#destroy", :id => "1")
    end

  end
end
