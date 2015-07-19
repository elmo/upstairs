require "rails_helper"

RSpec.describe HomeController, :type => :controller do
  describe "GET #index" do

    it "responds successfully with an HTTP 200 status code" do
      get :about
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("about")
    end

    it "responds successfully with an HTTP 200 status code" do
      get :contact
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("contact")
    end

    it "responds successfully with an HTTP 200 status code" do
      get :terms_of_service
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("terms_of_service")
    end

    it "responds successfully with an HTTP 200 status code" do
      get :privacy
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("privacy")
    end
  end
end
