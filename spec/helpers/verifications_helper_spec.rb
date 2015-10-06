require 'rails_helper'

RSpec.describe VerificationsHelper, type: :helper do
  describe "verified_link" do

    before(:each) do
      load_user
      load_verifier
      load_valid_building
    end

    it "not verified when there is no matching verification record" do
      expect(helper.verified_link(@user, @building)).to eq "not verified"
    end

    it "verified when there is a matching verification record" do
      expect {@user.verify_ownership(@building, @verifier) }.to change(Verification, :count).by(1)
      expect(helper.verified_link(@user, @building)).to eq "verified"
    end

  end
end