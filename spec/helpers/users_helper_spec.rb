require 'rails_helper'
RSpec.describe UsersHelper, :type => :helper do

  describe "verfified_link" do
    before(:each) do
      load_user
      load_valid_building
    end

    it "verified_link" do
       expect(helper.verified_link(@user, @building)).to be_false
    end

  end

end
