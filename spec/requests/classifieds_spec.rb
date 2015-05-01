require 'rails_helper'

RSpec.describe "Classifieds", :type => :request do
  describe "GET /classifieds" do
    it "works! (now write some real specs)" do
      get classifieds_path
      expect(response).to have_http_status(200)
    end
  end
end
